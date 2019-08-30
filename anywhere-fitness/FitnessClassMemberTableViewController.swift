//
//  FitnessClassTableViewController.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/22/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class FitnessClassMemberTableViewController: UITableViewController {
    
    var memberController = MemberController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if memberController.bearer == nil {
            performSegue(withIdentifier: "MemberToLogInVC", sender: self)
        } else {
            self.memberController.fetchClasses { (error) in
                if let error = error {
                    print(error)
                    return
                } else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        print(self.memberController.fitnessClasses)
                    }
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memberController.fitnessClasses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCellClient", for: indexPath)
        let fitnessClass = self.memberController.fitnessClasses[indexPath.row]
        cell.textLabel?.text = "\(fitnessClass.name) - \(fitnessClass.time)"
        cell.detailTextLabel?.text = fitnessClass.description
        AppearanceHelper.styleForMember(cell: cell)
        return cell
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemberToLogInVC" {
            guard let destVC = segue.destination as? MemberLogInViewController else {return}
            destVC.memberController = self.memberController
        }
    }
    
    
    private func updateViews() {
        //this could be used with customeCell
    }
    
}
