//
//  DrawPathViewModel.swift
//  Draw
//
//  Created by Eduardo Fornari on 20/08/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import Firebase

class DrawPathViewModel {

    var room: Room?

    init(room: Room) {
        self.room = room
    }

    public func save(with drawPath: DrawPath, completion: @escaping (Error?) -> Void) {
        DataManager.shared.save(data: drawPath, typeName: DrawPath.typeName, completion: completion)
    }

    public func delete(with identifier: String, completion: @escaping (Error?) -> Void) {
        DataManager.shared.delete(for: DrawPath.typeName, with: identifier, completion: completion)
    }

    private func fetchDrawPaths(completion: @escaping ([DrawPath]?) -> Void) {
        if let roomID = room?.identifier {
            let databaseReference: DatabaseReference = Database.database().reference()
            let query = databaseReference.child(DrawPath.typeName).queryOrdered(byChild:
                "roomID").queryEqual(toValue: roomID)
            DataManager.shared.query(query: query, completion: completion)
        }
    }

    public func clearPath(completion: @escaping (Error?) -> Void) {
        fetchDrawPaths() { (paths) in
            if let paths = paths {
                let group = DispatchGroup()
                for path in paths {
                    group.enter()
                    self.delete(with: path.identifier!, completion: { (error) in
                        group.leave()
                    })
                }
                group.notify(queue: .main, execute: {
                    completion(nil)
                })
            }
        }
    }

    public func fetchDrawPathAddedObservable(completion: @escaping (DrawPath?) -> Void) {
        if let roomID = room?.identifier {
            let databaseReference: DatabaseReference = Database.database().reference()
            let query = databaseReference.child(DrawPath.typeName).queryOrdered(byChild:
                "roomID").queryEqual(toValue: roomID)
            DataManager.shared.queryObservableChildAdded(query: query, completion: completion)
        }
    }
    
    public func fetchDrawPathRemovedObservable(completion: @escaping (DrawPath?) -> Void) {
        if let roomID = room?.identifier {
            let databaseReference: DatabaseReference = Database.database().reference()
            let query = databaseReference.child(DrawPath.typeName).queryOrdered(byChild:
                "roomID").queryEqual(toValue: roomID)
            DataManager.shared.queryObservableChildRemoved(query: query, completion: completion)
        }
    }

}
