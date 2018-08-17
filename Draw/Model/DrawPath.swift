//
//  DrawPath.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct DrawPath {
    var identifier: String?
    var color: UIColor
    internal var points: [CGPoint] = []
    var roomID: String

    init(color: UIColor, point1: CGPoint, point2: CGPoint, roomID: String) {
        self.identifier = UUID().uuidString

        self.color = color
        self.points.append(point1)
        self.points.append(point2)
        self.roomID = roomID
    }

}

extension DrawPath: CloudConvertible {
    static var typeName: String {
        return "DrawPath"
    }
    
    func intoFBObject() -> [String : Any] {
        var fbObject = [String: Any]()
        
        fbObject["identifier"] = identifier
        fbObject["color"] = color.toString()
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
            let color = fbObject["color"] as? String,
            let dicPoints = fbObject["points"] as? [[String: Double]],
            let roomID = fbObject["roomID"] as? String else { return nil }
        
        self.identifier = identifier
        if let color = UIColor.fromString(colorRGBA: color) {
            self.color = color
        } else {
            self.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        self.points = dicPoints.map { (dict) -> CGPoint in
            return CGPoint(x: dict["x"] ?? 0, y: dict["y"] ?? 0)
        }
        self.roomID = roomID
    }

}

extension UIColor {
    func toString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return "\(red);\(green);\(blue);\(alpha);"
    }

    static func fromString(colorRGBA: String) -> UIColor? {
        let nsNumberFormatter = NumberFormatter()
        
        let rgba = colorRGBA.components(separatedBy: ";")
        guard let red = nsNumberFormatter.number(from: rgba[0]),
        let green = nsNumberFormatter.number(from: rgba[1]),
        let blue = nsNumberFormatter.number(from: rgba[2]),
        let alpha = nsNumberFormatter.number(from: rgba[3]) else {
            return nil
        }

        return UIColor(red: CGFloat(truncating: red), green: CGFloat(truncating: green),
                       blue: CGFloat(truncating: blue), alpha: CGFloat(truncating: alpha))
    }
}
