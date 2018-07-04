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
        guard let id = value["id"] as? String else { return nil }
//        guard let isCompleted = value["isCompleted"] as? Bool else { return nil }
        guard let color = value["color"] as? String else { return nil }
        guard let points = value["points"] as? [[String: Double]]  else { return nil }
        
        self.id = id
        self.color = color
        self.isCompleted = false
        self.points = points.map { (dict) -> CGPoint in
            return CGPoint(x: dict["x"] ?? 0, y: dict["y"] ?? 0)
        }
    }
    
    func asDictonary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["id"] = id
        dict["color"] = color
        dict["points"] = points.map({ (point) -> [String: Any] in
            return [
                "x": point.x,
                "y": point.y
            ]
        })
        return dict
    }
}

class DatabaseAcess {
    
    static let share = DatabaseAcess()
    
    let database = Database.database().reference()
    
    private init() {}
    
    deinit {
        database.removeAllObservers()
    }
    
    func changes(completion: @escaping ([DrawPath]) -> Void ) {
        database.child("DrawPath").observe(.value) { (snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                completion([])
                return
            }
            let drawPaths = snapshots.compactMap(DrawPath.init)
            completion(drawPaths)
        }
    }
    
    func save(_ drawPath: DrawPath) {
        database.child("DrawPath").child(drawPath.id).updateChildValues(drawPath.asDictonary())
    }
    
    func savePoint(_ drawPath: DrawPath) {
        guard let lastPoint = drawPath.points.last else { return }
        let point = ["x": lastPoint.x, "y": lastPoint.y ]
        let values = ["/Drawpath/\(drawPath.id)/points/": point]
        database.updateChildValues(values)
    }
}
