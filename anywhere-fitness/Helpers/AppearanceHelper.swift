//
//  AppearanceHelper.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/29/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import UIKit

//Bangers cursive and "Titillium Web", sans-serif

enum AppearanceHelper {
    
    static var backgroundPurple = #colorLiteral(red: 0.4121550322, green: 0.2720786929, blue: 0.5838066936, alpha: 1)
    static var mainColorLightBlue = #colorLiteral(red: 0.299828887, green: 0.6432801485, blue: 0.7958413363, alpha: 1)
    
    static func setAppearance() {
        UINavigationBar.appearance().barTintColor = backgroundPurple
        UIBarButtonItem.appearance().tintColor = mainColorLightBlue
        
        let textAtributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().titleTextAttributes = textAtributes
        UINavigationBar.appearance().largeTitleTextAttributes = textAtributes
        
        UITextField.appearance().tintColor = mainColorLightBlue
        UITextField.appearance().textColor = mainColorLightBlue
    }
    
    static func styleForInstructor(cell: UITableViewCell) {
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .yellow
        cell.backgroundColor = AppearanceHelper.backgroundPurple
    }
    static func styleForMember(cell: UITableViewCell) {
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .yellow
        cell.backgroundColor = AppearanceHelper.mainColorLightBlue
    }
    
}
