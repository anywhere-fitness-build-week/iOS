//
//  FitnessClassTableViewController.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/22/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class FitnessClassTableViewController: UITableViewController {
    
    var instructorController = InstructorController()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if instructorController.bearer == nil {
            performSegue(withIdentifier: "InstructorToLogInVC", sender: self)
        } else {
            self.instructorController.fetchClasses { (error) in
                if let error = error {
                    print(error)
                    return
                } else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        print(self.instructorController.fitnessClasses)
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
        
        return self.instructorController.fitnessClasses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)
        let fitnessClass = self.instructorController.fitnessClasses[indexPath.row]
        cell.textLabel?.text = fitnessClass.name
        cell.detailTextLabel?.text = fitnessClass.description
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
        if segue.identifier == "InstructorToLogInVC" {
            guard let destVC = segue.destination as? InstructorLogInViewController else {return}
                destVC.instructorController = self.instructorController
        } else if segue.identifier == "InstructorToAddClass" {
            guard let destVC = segue.destination as? FitnessClassDetailViewController else {return}
                destVC.instructorController = self.instructorController
        } else if segue.identifier == "InstructorToShowClass" {
            guard let destVC = segue.destination as? FitnessClassDetailViewController,
                    let selectedRow = self.tableView.indexPathForSelectedRow else {return}
                destVC.instructorController = self.instructorController
                destVC.fitnessClass = self.instructorController.fitnessClasses[selectedRow.row]
            
        }
     }

    
    private func updateViews() {
    }
    
}
