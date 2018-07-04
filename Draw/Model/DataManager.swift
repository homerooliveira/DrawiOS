//
//  DataManagerBackup.swift
//  Draw
//
//  Created by Eduardo Fornari on 18/04/18.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class DataManager {

    static let sharedInstance = DataManager()

    private init() {}

    // MARK: - Save

    public func save<T: CloudConvertible>(data: T, typeName: String,
                                          completion: @escaping (Error?) -> Void) {

        let object = data.intoFBObject()
        let database: DatabaseReference = Database.database().reference()

        if let identifier = data.identifier {
            database.child(typeName).child(identifier).updateChildValues(object) { (error, _) in
                completion(error)
            }
        } else {
            database.child(typeName).childByAutoId().setValue(object, withCompletionBlock: { (error, fff) in
                completion(error)
            })
        }
    }

//    public func save(image: UIImage, for path: String, with identifier: String, completion: @escaping (StorageMetadata?, Error?) -> Void) {
//        if let data = UIImageJPEGRepresentation(image, 1) {
//            let imageReference = Storage.storage().reference().child("\(path)/")
//
//            let uploadImageRef = imageReference.child(identifier)
//            _ = uploadImageRef.putData(data, metadata: nil) { (metadata, error) in
//                completion(metadata, error)
//            }
//        } else {
//            completion(nil, nil)
//        }
//    }

    // MARK: - Fetch

    public func fetch<T: CloudConvertible>(typeName: String, completion: @escaping ([T]?) -> Void) {

        let database: DatabaseReference = Database.database().reference()

        database.child(typeName).observeSingleEvent(of: .value) { (dataSnapshot) in
            var result = [T]()

            if let values = dataSnapshot.value as? [String: Any] {
                var aux = [[String: Any]]()

                for postValue in values {
                    if let value = postValue.value as? [String: Any] {
                        var newValue = value
                        newValue["identifier"] = postValue.key
                        aux.append(newValue)
                    }
                }
                result = aux.compactMap { T.init($0) } // map & remove nils
                completion(result)
            } else {
                completion(result)
            }
        }
    }

    public func fetchObservable<T: CloudConvertible>(eventType: DataEventType, typeName: String,
                                                     completion: @escaping ([T]?) -> Void) {

        let database: DatabaseReference = Database.database().reference()

        database.child(typeName).observe(eventType) { (dataSnapshot) in
            var result = [T]()

            if let values = dataSnapshot.value as? [String: Any] {
                var aux = [[String: Any]]()

                for postValue in values {
                    if let value = postValue.value as? [String: Any] {
                        var newValue = value
                        newValue["identifier"] = postValue.key
                        aux.append(newValue)
                    }
                }
                result = aux.compactMap { T.init($0) } // map & remove nils
                completion(result)
            } else {
                completion(result)
            }
        }

    }

//    public func fetchImage(for path: String, with identifier: String, completion: @escaping (UIImage?) -> Void) {
//        let imageReference = Storage.storage().reference().child("\(path)/")
//        let downloadImageRef = imageReference.child(identifier)
//        _ = downloadImageRef.getData(maxSize: 1024 * 1024 * 1024 * 1024) { (data, error) in
//            if let data = data {
//                let image = UIImage(data: data)
//                completion(image)
//            } else {
//                completion(nil)
//            }
//        }
//    }

    // MARK: - Delete

    public func delete(for typeName: String, with identifier: String, completion: @escaping (Error?) -> Void) {
        let databaseReference: DatabaseReference = Database.database().reference().child(typeName).child(identifier)
        databaseReference.removeValue { error, _ in
            completion(error)
        }
    }

    // MARK: - Query

    public func query<T: CloudConvertible>(query: DatabaseQuery, completion: @escaping ([T]?) -> Void) {

        query.observeSingleEvent(of: .value) { (dataSnapshot) in
            var result = [T]()

            if let values = dataSnapshot.value as? [String: Any] {
                var aux = [[String: Any]]()

                for postValue in values {
                    if let value = postValue.value as? [String: Any] {
                        var newValue = value
                        newValue["identifier"] = postValue.key
                        aux.append(newValue)
                    }
                }
                result = aux.compactMap { T.init($0) } // map & remove nils
                completion(result)
            } else {
                completion(result)
            }
        }
    }

    public func queryObservable<T: CloudConvertible>(query: DatabaseQuery, eventType: DataEventType,
                                                     completion: @escaping ([T]?) -> Void) {

        query.observe(eventType) { (dataSnapshot) in
            var result = [T]()
            if let values = dataSnapshot.value as? [String: Any] {
                var aux = [[String: Any]]()

                for postValue in values {
                    if let value = postValue.value as? [String: Any] {
                        var newValue = value
                        newValue["identifier"] = postValue.key
                        aux.append(newValue)
                    }
                }
                result = aux.compactMap { T.init($0) } // map & remove nils
                completion(result)
            } else {
                completion(result)
            }
        }
    }

    public func queryObservableChildAdded<T: CloudConvertible>(query: DatabaseQuery,
                                                               completion: @escaping (T?) -> Void) {

        query.observe(.childAdded) { (dataSnapshot) in
            if let value = dataSnapshot.value as? [String: Any] {
                completion(T.init(value))
            } else {
                completion(nil)
            }
        }
    }

    // MARK: - Firebase User

//    public func login(with email: String, and password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
//            completion(authDataResult, error)
//        }
//    }

//    public func logout() {
//        do {
//            try Auth.auth().signOut()
//        } catch { }
//    }

//    public func currentUser() -> User? {
//        let user = Auth.auth().currentUser
//        return user
//    }

//    public func createAccount(with email: String, and password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
//            completion(authDataResult, error)
//        }
//    }

//    public func deleteAccount(completion: @escaping (Error?) -> Void) {
//        Auth.auth().currentUser?.delete(completion: { error in
//            completion(error)
//        })
//    }

}
