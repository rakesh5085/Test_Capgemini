//  LastSearchViewController.swift
//  Assignment_Test

import UIKit
import CoreData

// This class represents the Last Search View Controller, which displays
// the list of repositories from the last search.
class LastSearchViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UIViewControllerTransitioningDelegate{
    
    // Array to store the list of repositories.
    var arrListRepo = [[String: Any]]();
    
    // Outlet for the table view where the list of repositories will be displayed.
    @IBOutlet weak var tblView: UITableView!
    
    // Array to store the repository data fetched from CoreData.
    var repoData: [NSManagedObject] = []
    
    // Instance of Interactor class.
    let interactor = Interactor()
    
    // Variable to store the index of the selected repository.
    var selectedIndex = 0;
    
    // The viewDidLoad method is called when the view controller is loaded into memory.
    // Here, it is used to set up the navigation bar and fetch the records from CoreData.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the navigation bar.
        self.navigationController?.navigationBar.isHidden = false
        
        // Fetch the records from CoreData.
        self.fetchRecord();
    }
    
    // Prepare for the segue to ModalViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the destination view controller is ModalViewController, set its transitioningDelegate,
        // strURL, and interactor properties.
        if let destinationViewController = segue.destination as? ModalViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.strURL = self.arrListRepo[selectedIndex]["url"] as? String ?? ""
            destinationViewController.interactor = interactor
        }
    }
    
    // Action method for the cancel button.
    @objc func cancelAction() {
        // Dismiss the view controller.
        self.dismiss(animated: true, completion: nil)
    }
    
    // Action method for the refresh button.
    @objc func refreshAction() {
        // Reload the web view.
//        self.webView.reload()
    }
    
    // Required method to specify the number of rows in the table view.
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.arrListRepo.count
    }
    
    // Required method to specify the contents of each cell in the table view.
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Dequeue a reusable cell with the identifier "TableViewCustomCell".
        let cell =
            tableView.dequeueReusableCell(withIdentifier:
                                            "TableViewCustomCell", for: indexPath) as! TableViewCustomCell
        
        // Set the text of the title label to the full name of the repository.
        cell.lblTItleName?.text = self.arrListRepo[indexPath.row]["full_name"] as? String
        
        // Set the text of the subtitle label to the ID of the repository.
        cell.lblSubName?.text = String(self.arrListRepo[indexPath.row]["id"] as! Int)
        
        // Set the selection style of the cell to none.
        cell.selectionStyle = .none
        
        return cell
    }
    
    // Method to handle the selection of a row in the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set the selected index.
        selectedIndex = indexPath.row
    }
    
    // Method to fetch the records from CoreData.
    func fetchRecord() {
        // 1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          // 2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "RepoData")
          
          // 3
          do {
            repoData = try managedContext.fetch(fetchRequest)
            self.arrListRepo.removeAll()
            for data in repoData{
                let obj: [String: Any] = [
                    "full_name": data.value(forKey: "name") as! String,
                    "url": data.value(forKey: "url") as! String,
                    "id": data.value(forKey: "id") as! Int,
                    "readStatus": false
                    
                ]
                self.arrListRepo.append(obj);
                print("Data :", data.value(forKey: "name") as! String)
            }
            self.tblView.reloadData()
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
    }

}

