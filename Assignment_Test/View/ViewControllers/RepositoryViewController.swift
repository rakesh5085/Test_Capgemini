//
//  ViewController.swift
//

import UIKit
import WebKit
import CoreData


class RepositoryViewController: UIViewController , UITableViewDelegate,UITableViewDataSource ,UISearchBarDelegate, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var btnSignIn: UIButton!
    var webView = WKWebView()
    var strUserName = ""
    var arrListRepo = [[String: Any]]();
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let interactor = Interactor()
    var strLoginStatus = "0";
    var repoData: [NSManagedObject] = []
    var selectedIndex = 0;
    
    var arrRepo = [Repository]()
    
    let presenter = RepositoryPresenter(githubService: GithubService())
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ModalViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.strURL = self.arrRepo[selectedIndex].url ?? ""
            destinationViewController.interactor = interactor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(view: self)
        if (UserDefaults.standard.value(forKey: Constants.Keys.loginStatus) != nil){
            strLoginStatus = UserDefaults.standard.value(forKey: Constants.Keys.loginStatus) as! String;
        }else{
            UserDefaults.standard.setValue("0", forKey: Constants.Keys.loginStatus);
        }
        if strLoginStatus == "0" {
            btnSignIn.setTitle(Constants.Strings.login, for: .normal);
            searchBar.isUserInteractionEnabled = false
        }else{
            btnSignIn.setTitle(Constants.Strings.logOut, for: .normal);
            searchBar.isUserInteractionEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnTappedSignIn(_ sender: UIButton) {
        if strLoginStatus == "0" {
            githubAuthVC()
        }else{
            btnSignIn.setTitle(Constants.Strings.login, for: .normal);
            searchBar.isUserInteractionEnabled = false
            strLoginStatus = "0";
            UserDefaults.standard.setValue("0", forKey: Constants.Keys.loginStatus);
        }
    }
    
    func githubAuthVC() {
        let githubVC = UIViewController()
        let uuid = UUID().uuidString
        let webView = WKWebView()
        webView.navigationDelegate = self
        githubVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: githubVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: githubVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: githubVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: githubVC.view.trailingAnchor)
        ])
        
        let authURLFull = Constants.GithubConstants.AUTHBASEURL + "" + Constants.GithubConstants.CLIENT_ID + "&scope=" + Constants.GithubConstants.SCOPE + "&redirect_uri=" + Constants.GithubConstants.REDIRECT_URI + "&state=" + uuid
        
        let urlRequest = URLRequest(url: URL(string: authURLFull)!)
        webView.load(urlRequest)
        
        let navController = UINavigationController(rootViewController: githubVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        githubVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        githubVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        githubVC.navigationItem.title = Constants.Strings.githubTitle
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.black
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
        self.webView.reload()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRepo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.repoTableCell, for: indexPath) as! TableViewCustomCell
        cell.lblTItleName?.text = self.arrRepo[indexPath.row].name
        cell.lblSubName?.text = String(self.arrRepo[indexPath.row].id ?? 0)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.getRepositoryList(searchText: searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.getRepositoryList(searchText: searchBar.text ?? "")
    }
    
    //TODO: to be moved to presenter 
    func someEntityExists(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.Keys.repoData)
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        var results: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        do {
            results = try managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    func saveData() {
        for data in self.arrRepo {
            if someEntityExists(id: data.id ?? 0) == false{
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: Constants.Keys.repoData, in: managedContext)!
                let repo = NSManagedObject(entity: entity, insertInto: managedContext)
                repo.setValue(data.name, forKeyPath: Constants.Keys.name)
                repo.setValue(false, forKeyPath: Constants.Keys.readStatus)
                repo.setValue(data.id, forKeyPath: Constants.Keys.id)
                repo.setValue(data.url, forKeyPath: Constants.Keys.url)
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
}


extension RepositoryViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.RequestForCallbackURL(request: navigationAction.request)
        decisionHandler(.allow)
    }
    
    func RequestForCallbackURL(request: URLRequest) {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(Constants.GithubConstants.REDIRECT_URI) {
            if requestURLString.contains("code=") {
                if let range = requestURLString.range(of: "=") {
                    let githubCode = requestURLString[range.upperBound...]
                    if let range = githubCode.range(of: "&state=") {
                        let githubCodeFinal = githubCode[..<range.lowerBound]
                        self.presenter.getUserProfile(authCode: String(githubCodeFinal))
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension RepositoryViewController: RepositoryView {

    func updateView(displayName: String) {
        self.strUserName = displayName
        DispatchQueue.main.async {
            self.btnSignIn.setTitle(Constants.Strings.logOut, for: .normal);
            UserDefaults.standard.setValue("1", forKey: Constants.Keys.loginStatus);
            self.searchBar.isUserInteractionEnabled = true
            self.strLoginStatus = "1";
        }
    }
    
    func setRepositoryList(repositoryList: [Repository]) {
        self.arrRepo.removeAll()
        self.arrRepo = repositoryList
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
        self.saveData()
    }
    
    func setEmptyRepositoryList() {
        tblView.reloadData()
    }
}




