//
//  FitnessClassDetailViewController.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/23/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import Foundation

class FitnessClassDetailViewController: UIViewController {
    
    var instructorController: InstructorController!
    
    var fitnessClass: FitnessClass? {
        didSet {
            self.updateViews()
        }
    }
    
    
    @IBOutlet weak var fitnessClassNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func SaveButtonTapped(_ sender: Any) {
        if let fitnessClassName = self.fitnessClassNameTextField.text,
            let bearer = self.instructorController.bearer   {
            
            //update fitnessClasse
            if let fitnessClass = self.fitnessClass {
                self.instructorController.updateFitnessClass(for: fitnessClass, ChangeNameTo: fitnessClassName) { (error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                
                //createClass
                //pass instructor's id
                let instructorId = bearer.instructor[0].id
                self.instructorController.createClass(name: fitnessClassName, instructorId: instructorId, categoryId: 1, description: "", time: "") { (error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            print("name and instructor ID are required but missing here!!")
        }
    }
    
    private func updateViews() {
        if let fitnessClass = self.fitnessClass {
        self.fitnessClassNameTextField?.text = fitnessClass.name
            self.navigationItem.title = "\(fitnessClass.name)"
        } else {
            self.navigationItem.title = "Create Class"
        }
    }
    
}
