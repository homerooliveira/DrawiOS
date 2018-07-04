//
//  DataBaseAcess.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DrawPath {
    init?(_ snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        guard let id = value["identifier"] as? String else { return nil }
//        guard let isCompleted = value["isCompleted"] as? Bool else { return nil }
        guard let color = value["color"] as? String else { return nil }
        guard let points = value["points"] as? [[String: Double]]  else { return nil }
        guard let roomID = value["roomID"] as? String  else { return nil }
        
        self.identifier = id
        self.color = color
        self.isCompleted = false
        self.points = points.map { (dict) -> CGPoint in
            return CGPoint(x: dict["x"] ?? 0, y: dict["y"] ?? 0)
        }
        self.roomID = roomID
    }
}

class DatabaseAcess {
    
    static let share = DatabaseAcess()
    
    let database = Database.database().reference()
    
    private init() {}
    
    deinit {
        database.removeAllObservers()
    }

    public func fetchDrawPathsObservable(for roomID: String, completion: @escaping ([DrawPath]?) -> Void) {
        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(DrawPath.typeName).queryOrdered(byChild:
            "roomID").queryEqual(toValue: roomID)
        DataManager.sharedInstance.queryObservable(query: query, eventType: .value, completion: completion)
    }
    
    func removeAllObservers() {
        database.removeAllObservers()
    }

    // MARK: SAVE

    public func save(with drawPath: DrawPath, completion: @escaping (Error?) -> Void) {
        DataManager.sharedInstance.save(data: drawPath, typeName: DrawPath.typeName, completion: completion)
    }

    public func save(with room: Room, completion: @escaping (Error?) -> Void) {
        DataManager.sharedInstance.save(data: room, typeName: Room.typeName, completion: completion)
    }

    func savePoint(_ drawPath: DrawPath) {
        guard let lastPoint = drawPath.points.last else { return }
        let point = ["x": lastPoint.x, "y": lastPoint.y ]
        let values = ["/Drawpath/\(drawPath.identifier)/points/": point]
        database.updateChildValues(values)
    }

    public func fetchRoomsObservable(completion: @escaping ([Room]?) -> Void) {
        DataManager.sharedInstance.fetchObservable(eventType: DataEventType.value, typeName: Room.typeName, completion: completion)
    }
}
