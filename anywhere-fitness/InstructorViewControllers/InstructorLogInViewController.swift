//
//  LogInViewController.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/21/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import Foundation

enum LoginType {
    case signUp
    case signIn
}

class InstructorLogInViewController: UIViewController {
    
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: UIButton!
    
    var instructorController: InstructorController!
    
    var loginType = LoginType.signUp
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        // perform login or sign up operation based on loginType
        
        if let username = self.usernameTextField.text,
            !username.isEmpty,
            let password = self.passwordTextField.text,
            !password.isEmpty,
            let fullname = self.fullnameTextField.text {
            
            let instructor = Instructor(fullname: fullname, username: username, password: password)
            
            if loginType == .signUp {
                instructorController.signUp(with: instructor) { (error) in
                    
                    if let error = error {
                        NSLog("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .signIn
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                                self.signInButton.setTitle("Sign In", for: .normal)
                                self.scControlOneTapped()
                            })
                        }
                    }
                }
            } else {
                instructorController.signIn(with: instructor) { (error) in
                    if let error = error {
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.loginType = .signUp
            self.signInButton.setTitle("Sign Up", for: .normal)
            resetAnimation()
        } else {
            self.loginType = .signIn
            self.signInButton.setTitle("Sign In", for: .normal)
            scControlOneTapped()
        }
    }
    
    //animation for fullNameTextField
    func scControlOneTapped() {
        let animBlock = {
            UITextField.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
                self.fullnameTextField.transform = CGAffineTransform(rotationAngle: CGFloat(Int.random(in: -360...360)))
            })
            
            UITextField.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3, animations: {
                self.fullnameTextField.backgroundColor = UIColor(red: CGFloat(Int.random(in: 0...255)) / 255, green: CGFloat(Int.random(in: 0...255)) / 255, blue: CGFloat(Int.random(in: 0...255)) / 255, alpha: 1)
            })
            
            UITextField.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8, animations: {
                self.fullnameTextField.alpha = 0
            })
        }
        UITextField.animateKeyframes(withDuration: 1.5, delay: 0.0, options: [], animations: animBlock, completion: nil)
    }
    
    func resetAnimation() {
        let animBlock = {
            UITextField.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: {
                self.fullnameTextField.transform = .identity
                self.fullnameTextField.alpha = 1
                self.fullnameTextField.backgroundColor = .white
            })
        }
        UITextField.animateKeyframes(withDuration: 1.5, delay: 0.0, options: [], animations: animBlock, completion: nil)
    }
}

