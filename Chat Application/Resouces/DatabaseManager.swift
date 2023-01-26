//
//  DatabaseManager.swift
//  Chat Application
//
//  Created by Nikhil Mac on 03/01/23.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    static func safeEmail(emailAddress:String)->String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
    
    
}


extension DatabaseManager{
    
    public func userExists(with email:String,completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            
            guard snapshot.value as? [String:String] != nil else {
                completion(false)
                let ni = snapshot
                print(ni)
                return
            }
            completion(true)
        }
    }
    
    
    //get users from database
    public func getAllUsers(completion: @escaping (Result<[[String:String]],Error>)->Void){
        
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String:String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
        
    }
    
    //errors to show
    public enum DatabaseError:Error {
        case failedToFetch
    }
    
    //insert new user to database
    public func insertUser(with user:ChatAppUser, completion: @escaping (Bool) -> Void){
        database.child(user.safeEmail).setValue([
                                                    "first_name": user.firstName,
                                                    "last_name": user.lastName]) { error, _ in
            guard error == nil else {
                print("fail to write to database")
                completion(false)
                return
            }
            //completion(true)
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                if var usersCollection = snapshot.value as? [[String:String]] {
                    //append to user dictionary
                    let newElement =  [
                        "name":user.firstName + " " + user.lastName,
                        "email":user.safeEmail
                    ]
                    if !usersCollection.contains(newElement){
                        
                        usersCollection.append(newElement)
                        self.database.child("users").setValue(usersCollection) { error, reference in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                        
                    }
                        
                    }
                    completion(true)

                }else {
                    //create that array
                    let newCollection:[[String:String]] = [ [
                        "name":user.firstName + " " + user.lastName,
                        "email":user.safeEmail
                    ]
                    ]

                    self.database.child("users").setValue(newCollection) { error, reference in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                        return
                        
                    }

                }
            }
            
        }
    }
    
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress:String
    var safeEmail:String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
    var profilePictureFileName: String{
        return "\(safeEmail)_profile_picture.png"
    }
    
}


