//  ViewController.swift
//  RepositoryApp

import UIKit
import WebKit
import CoreData

// RepositoryViewController is a subclass of UIViewController and conforms to UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIViewControllerTransitioningDelegate protocols.
class RepositoryViewController: UIViewController , UITableViewDelegate,UITableViewDataSource ,UISearchBarDelegate, UIViewControllerTransitioningDelegate {
    
    // Outlet for the Sign In button
    @IBOutlet weak var btnSignIn: UIButton!
    // WebView for displaying GitHub webpages
    var webView = WKWebView()
    // Stores the GitHub user's username
    var strUserName = ""
    // Stores the list of repositories fetched from GitHub API
    var arrListRepo = [[String: Any]]();
    // Outlet for the tableView
    @IBOutlet weak var tblView: UITableView!
    // Outlet for the searchBar
    @IBOutlet weak var searchBar: UISearchBar!
    // Interactor object for handling network requests
    let interactor = Interactor()
    // Stores the login status of the user
    var strLoginStatus = "0";
    // Stores the list of CoreData objects for repositories
    var repoData: [NSManagedObject] = []
    // Stores the index of the selected row in the tableView
    var selectedIndex = 0;
    
    // Array of Repository objects
    var arrayRepo = [Repository]()
    
    // Presenter object for handling repository related operations
    let presenter = RepositoryPresenter(githubService: GithubService())
    
    // prepareForSegue method is called before a segue is performed. It is used to pass data to the destination view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ModalViewController {
            // Setting the transitioningDelegate property of the destination view controller to self
            destinationViewController.transitioningDelegate = self
            // Passing the URL of the selected repository to the destination view controller
            destinationViewController.strURL = self.arrayRepo[selectedIndex].url ?? ""
            // Passing the interactor object to the destination view controller
            destinationViewController.interactor = interactor
        }
    }
    
    // viewDidLoad method is called after the view controller has loaded its view hierarchy into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initializing the presenter object and attaching the view to it
        presenter.attachView(view: self)
        // Checking if the user's login status is saved in UserDefaults
        if (UserDefaults.standard.value(forKey: Constants.Keys.loginStatus) != nil){
            strLoginStatus = UserDefaults.standard.value(forKey: Constants.Keys.loginStatus) as! String;
        }else{
            UserDefaults.standard.setValue("0", forKey: Constants.Keys.loginStatus);
        }
        // Setting the title of the Sign In button based on the user's login status
        if strLoginStatus == "0" {
            btnSignIn.setTitle(Constants.Strings.login, for: .normal);
            searchBar.isUserInteractionEnabled = false
        }else{
            btnSignIn.setTitle(Constants.Strings.logOut, for: .normal);
            searchBar.isUserInteractionEnabled = true
        }
    }
    
    // viewWillAppear method is called every time the view controller is about to appear on the screen.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // btnTappedSignIn method is called when the Sign In button is tapped.
    @IBAction func btnTappedSignIn(_ sender: UIButton) {
        if strLoginStatus == "0" {
            // Calling the githubAuthVC method to authenticate the user
            githubAuthVC()
        }else{
            // Setting the title of the Sign In button to "Login" and disabling the searchBar
            btnSignIn.setTitle(Constants.Strings.login, for: .normal);
            searchBar.isUserInteractionEnabled = false
            // Setting the login status to "0" and saving it in UserDefaults
            strLoginStatus = "0";
            UserDefaults.standard.setValue("0", forKey: Constants.Keys.loginStatus);
        }
    }
    
    // githubAuthVC method is used to authenticate the user using OAuth 2.0 authorization code flow.
    func githubAuthVC() {
        // Creating a new view controller and adding a WKWebView to it
        let githubVC = UIViewController()
        let uuid = UUID().uuidString
        let webView = WKWebView()
        webView.navigationDelegate = self
        githubVC.view.addSubview(webView)
        // Setting up constraints for the webView
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: githubVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: githubVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: githubVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: githubVC.view.trailingAnchor)
        ])
        // Constructing the authorization URL
        let authURLFull = Constants.GithubConstants.AUTHBASEURL + "" + Constants.GithubConstants.CLIENT_ID + "&scope=" + Constants.GithubConstants.SCOPE + "&redirect_uri=" + Constants.GithubConstants.REDIRECT_URI + "&state=" + uuid
        // Creating a URL request for the authorization URL
        let urlRequest = URLRequest(url: URL(string: authURLFull)!)
        // Loading the URL request in the webView
        webView.load(urlRequest)
        // Creating a navigation controller with the githubVC as the
