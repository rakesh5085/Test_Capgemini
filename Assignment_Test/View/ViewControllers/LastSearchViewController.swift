//
//  LastSearchViewController.swift
//  Assignment_Test

import UIKit
import CoreData

//TODO: a presenter needs to be created corresponding to this

class LastSearchViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UIViewControllerTransitioningDelegate{
    var arrListRepo = [[String: Any]]();
    @IBOutlet weak var tblView: UITableView!
    var repoData: [NSManagedObject] = []
    let interactor = Interactor()
    var selectedIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        self.fetchRecord();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ModalViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.strURL = self.arrListRepo[selectedIndex]["url"] as? String ?? ""
            destinationViewController.interactor = interactor
        }
    }
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
//        self.webView.reload()
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.arrListRepo.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(withIdentifier:
                                            "TableViewCustomCell", for: indexPath) as! TableViewCustomCell
        
        cell.lblTItleName?.text = self.arrListRepo[indexPath.row]["full_name"] as? String
        cell.lblSubName?.text = String(self.arrListRepo[indexPath.row]["id"] as! Int)
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
    //TODO: to be moved to presenter
    func fetchRecord() {
        //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "RepoData")
          
          //3
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
//            print("repodata count ", repoData[0].name);
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
    }

}
