//
//  FitnessClassTableViewController.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/22/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class FitnessClassTableViewController: UITableViewController, UISearchBarDelegate {
    
    let instructorController = InstructorController()

    @IBOutlet weak var searchUIView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var timeLabel: UILabel!
    
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
        
        guard let bearer = instructorController.bearer else { return }
        let fullName = bearer.instructor[0].fullname
        self.title = "Welcome, \(fullName)!"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.searchBar.delegate = self
        searchUIView.backgroundColor = AppearanceHelper.backgroundPurple
        searchBar.layer.borderColor = AppearanceHelper.mainColorLightBlue.cgColor
        searchBar.layer.borderWidth = 2
        searchBar.layer.cornerRadius = 15.0
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = AppearanceHelper.mainColorLightBlue
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.instructorController.fitnessClasses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)
        let fitnessClass = self.instructorController.fitnessClasses[indexPath.row]
        cell.textLabel?.text = "\(fitnessClass.name) - \(fitnessClass.time)"
        cell.detailTextLabel?.text = fitnessClass.description
        
        AppearanceHelper.styleForInstructor(cell: cell)
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let fitnesClass = self.instructorController.fitnessClasses[indexPath.row]
        self.instructorController.deleteFitnessClass(for: fitnesClass) { (error) in
            if let error = error {
                print(error)
                return
            }
            
        }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    //searchBarSearchButton
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        if let searchTerm = searchBar.text,
                !searchTerm.isEmpty {
            let filteredClasses = self.instructorController.fitnessClasses.filter {$0.name.contains(searchTerm)}
            self.instructorController.fitnessClasses = filteredClasses
            self.tableView.reloadData()
            
        } else {
            self.instructorController.fetchClasses { (error) in
                if let error = error {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
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
    
//    private func updateViews() {
//        //this could be used with customeCell
//    }
/*
 
     TEST COMMIT
 
*/
    
}
