//
//  MemberController.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/27/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethodClient: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class MemberController {
    
    var fitnessClasses: [FitnessClass] = []
    var bearer: BearerClient?
    
    private let baseUrl = URL(string: "https://anywhere-fitness-azra-be.herokuapp.com/api/")!
    //client-register and client-login for client
    
    //Sign up - POST
    func signUp(with instructor: Instructor, completion: @escaping (Error?)-> Void) {
        let signUpURL = baseUrl.appendingPathComponent("auth/client-register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethodClient.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(instructor)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
            print("passed signUp")
            }.resume()
    }
    
    //signIn - POST  - requried fields -> fullname, username, password
    func signIn(with instructor: Instructor, completion: @escaping (Error?) -> Void) {
        let signInURL = baseUrl.appendingPathComponent("auth/client-login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethodClient.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(instructor)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(error)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let bearer = try jsonDecoder.decode(BearerClient.self, from: data)
                self.bearer = bearer
                
                print(self.bearer!)
                completion(nil)
                
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    //Fetching Classes - GET - requried fields -> username, password
    func fetchClasses(completion: @escaping (Error?)-> Void) {
        
        guard let bearer = bearer else {
            print("there is no bearer for fetchingClassessss")
            return
        }
        
        let instructorURL = baseUrl.appendingPathComponent("classes")
        
        var request = URLRequest(url: instructorURL)
        request.httpMethod = HTTPMethodClient.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(bearer.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(error)
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(error)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let fitnessClasses = try jsonDecoder.decode([FitnessClass].self, from: data)
                self.fitnessClasses = fitnessClasses
                completion(nil)
            } catch {
                NSLog("Error decoding animal objects: \(error)")
                completion(error)
                return
            }
            }.resume()
    }

}
