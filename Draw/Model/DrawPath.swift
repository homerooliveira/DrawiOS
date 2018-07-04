//
//  DrawPath.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import CoreGraphics

struct DrawPath {
    var identifier: String?
    var isCompleted: Bool
    var color: String
    var points: [CGPoint]
    var roomID: String
}

extension DrawPath: CloudConvertible {
    static var typeName: String {
        return "DrawPath"
    }
    
    func intoFBObject() -> [String : Any] {
        var fbObject = [String: Any]()
        
        fbObject["identifier"] = identifier
        fbObject["isCompleted"] = isCompleted
        fbObject["color"] = color
        fbObject["points"] = points.map({ (point) -> [String: Any] in
            return [
                "x": point.x,
                "y": point.y
            ]
        })
        fbObject["roomID"] = roomID
        
        return fbObject
    }
    
    init?(_ fbObject: [String : Any]) {
        guard let identifier = fbObject["identifier"] as? String,
            let isCompleted = fbObject["isCompleted"] as? Bool,
            let color = fbObject["color"] as? String,
            let dicPoints = fbObject["points"] as? [[String: Double]],
            let roomID = fbObject["roomID"] as? String else { return nil }
        
        self.identifier = identifier
        self.isCompleted = isCompleted
        self.color = color
        self.points = dicPoints.map { (dict) -> CGPoint in
            return CGPoint(x: dict["x"] ?? 0, y: dict["y"] ?? 0)
        }
        self.roomID = roomID
    }
    
    
}
