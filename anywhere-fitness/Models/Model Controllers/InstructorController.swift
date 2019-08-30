//
//  InstructorController.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/21/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


class InstructorController {
    
    var fitnessClasses: [FitnessClass] = []

    var bearer: Bearer?
    
    private let baseUrl = URL(string: "https://anywhere-fitness-azra-be.herokuapp.com/api/")!
    //client-register and client-login for client
    
    //Sign up - POST
    func signUp(with instructor: Instructor, completion: @escaping (Error?)-> Void) {
        let signUpURL = baseUrl.appendingPathComponent("auth/register")
        
  //      let clientURL = baseUrl.appendingPathComponent("auth/client-register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
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
            print("passed sign in")
            }.resume()
    }
    
    //signIn - POST  - requried fields -> fullname, username, password
    func signIn(with instructor: Instructor, completion: @escaping (Error?) -> Void) {
        let signInURL = baseUrl.appendingPathComponent("auth/login")
        
//        let clientURL = baseUrl.appendingPathComponent("client-register")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
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
                let bearer = try jsonDecoder.decode(Bearer.self, from: data)
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
        request.httpMethod = HTTPMethod.get.rawValue
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
                let instructorId = self.bearer?.instructor[0].id
                let myFitnessClasses = fitnessClasses.filter{$0.instructorId == instructorId}
                self.fitnessClasses = myFitnessClasses
                completion(nil)
            } catch {
                NSLog("Error decoding animal objects: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
    
    //Creating Classes - POST - requried fields -> name, instructorId (bearer.insturctor[0].id), categoryId (just give it 1 now)
    func createClass(name: String, instructorId: Int, categoryId: Int, description: String, time: String, completion:@escaping(Error?)->()) {
        let fitnessClass = FitnessClass(id: nil, name: name, description: description, time: time, instructorId: instructorId, categoryId: categoryId)
        
        //POST
        let createFitnessClassURL = self.baseUrl.appendingPathComponent("classes")
        
        guard let bearer = self.bearer else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: createFitnessClassURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(bearer.token, forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        
        do {
            let jsonData = try jsonEncoder.encode(fitnessClass)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user objects: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let _ = error {
                completion(NSError())
                return
            }
            self.fitnessClasses.append(fitnessClass)
            completion(nil)
            }.resume()
    }
    
    //Updating Classes - PUT - classes/id# for class
    func updateFitnessClass(for fitnessClass: FitnessClass, ChangeNameTo: String, description: String, time: String, completion:@escaping (Error?)->Void) {
        
        //making sure passed fitnessClass exists in array of FitnessClass
        guard let index = self.fitnessClasses.firstIndex(of: fitnessClass) else {return}
        self.fitnessClasses[index].name = ChangeNameTo
        
        //let updatedClass = fitnessClasses[index]
        //PUT
        
        guard let fitnessClassId = fitnessClass.id else {return}
        
        let updateFitnessClassURL = self.baseUrl.appendingPathComponent(("classes/\(fitnessClassId)"))
        
        
        //creating its own json file for name change
        let params = ["name": ChangeNameTo,
                      "time": time,
                      "description": description] as [String: Any]
        let json = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        
        guard let bearer = self.bearer else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: updateFitnessClassURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(bearer.token, forHTTPHeaderField: "Authorization")
        
        request.httpBody = json
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                print(error)
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
    
    //Delete
    func deleteFitnessClass(for fitnessClass: FitnessClass, completion: @escaping (Error?) -> Void) {
        
        //Delete locally
        guard let index = self.fitnessClasses.firstIndex(of: fitnessClass) else {return}
        self.fitnessClasses.remove(at: index)
        
        
        
        guard let fitnessClassId =  fitnessClass.id else {return}
        
        let deleteFitnessClassURL = baseUrl.appendingPathComponent("classes/\(fitnessClassId)")
        
        
        guard let bearer = self.bearer else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: deleteFitnessClassURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(bearer.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                    return
                }
            }
            
            if let error = error {
                print(error)
                return
            }
            completion(nil)
            }.resume()
    }
}
