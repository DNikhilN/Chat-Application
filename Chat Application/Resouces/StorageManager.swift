//
//  StorageManager.swift
//  Chat Application
//
//  Created by Nikhil Mac on 19/01/23.
//

import UIKit
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias uploadPictureCompletion = (Result<String,Error>) -> Void
    
    public func uploadProfilePicture(with data: Data,fileName:String,completion:@escaping uploadPictureCompletion){
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metadata, error in
            guard error == nil else {
                print("failed to upload data to firebase for picture")
                completion(.failure(storageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("failed To Get Download Url")
                    completion(.failure(storageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
                
            }
        }
    }
    
    public enum storageErrors: Error{
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String,completion: @escaping (Result<URL,Error>)->Void){
        let reference = storage.child(path)
        reference.downloadURL { url, error in
            
            guard let url = url,error == nil else{
                completion(.failure(storageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
            
        }
    }
    
}
