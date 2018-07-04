//
//  DataBaseAcess.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseAcess {
    
    static let shared = DatabaseAcess()
    
    let database = Database.database().reference()
    
    private init() {}
    
    deinit {
        database.removeAllObservers()
    }
    
    func removeAllObservers() {
        database.removeAllObservers()
    }

    // MARK: SAVE

    public func save(with drawPath: DrawPath, completion: @escaping (Error?) -> Void) {
        DataManager.shared.save(data: drawPath, typeName: DrawPath.typeName, completion: completion)
    }

    public func save(with room: Room, completion: @escaping (Error?) -> Void) {
        DataManager.shared.save(data: room, typeName: Room.typeName, completion: completion)
    }

    func savePoint(_ drawPath: DrawPath) {
        guard let lastPoint = drawPath.points.last else { return }
        let point = ["x": lastPoint.x, "y": lastPoint.y ]
        let values = ["/Drawpath/\(drawPath.identifier)/points/": point]
        database.updateChildValues(values)
    }

    // MARK : Fetch

    public func fetchRoomsObservable(completion: @escaping ([Room]?) -> Void) {
        DataManager.shared.fetchObservable(eventType: DataEventType.value, typeName: Room.typeName, completion: completion)
    }

    public func fetchRoom(with name: String, completion: @escaping ([Room]?) -> Void) {
        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(Room.typeName).queryOrdered(byChild:
            "name").queryEqual(toValue: name)
        DataManager.shared.query(query: query, completion: completion)
    }

    public func fetchDrawPathsObservable(for roomID: String, completion: @escaping ([DrawPath]?) -> Void) {
        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(DrawPath.typeName).queryOrdered(byChild:
            "roomID").queryEqual(toValue: roomID)
        DataManager.shared.queryObservable(query: query, eventType: .value, completion: completion)
    }

    private func fetchDrawPaths(for roomID: String, completion: @escaping ([DrawPath]?) -> Void) {
        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(DrawPath.typeName).queryOrdered(byChild:
            "roomID").queryEqual(toValue: roomID)
        DataManager.shared.query(query: query, completion: completion)
    }

    // MARK : Delete

    public func deleteRoom(with roomID: String, completion: @escaping (Error?) -> Void) {
        DataManager.shared.delete(for: Room.typeName, with: roomID, completion: completion)
    }

    public func deleteDrawPath(with identifier: String, completion: @escaping (Error?) -> Void) {
        DataManager.shared.delete(for: DrawPath.typeName, with: identifier, completion: completion)
    }

    public func deleteAllDrawPaths(with roomID: String, completion: @escaping (Error?) -> Void) {
        fetchDrawPaths(for: roomID) { (paths) in
            if let paths = paths {
                for path in paths {
                    self.deleteDrawPath(with: path.identifier!, completion: { (error) in })
                }
            }
        }
    }

}
