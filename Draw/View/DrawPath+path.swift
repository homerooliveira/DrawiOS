//
//  DrawPath+path.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

extension DrawPath {
    var path: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = lineWidth

        guard let first = self.points.first else { return path }
        path.move(to: first)
        let points = self.points.dropFirst()
        
        points.forEach { (point) in
            path.addLine(to: point)
        }

        let rect = CGRect(x: first.x, y: first.y, width: 0, height: 0)
        let circle = UIBezierPath(roundedRect: rect, cornerRadius: lineWidth * 0.5)
        circle.lineWidth = lineWidth * 0.5
        path.append(circle)

        path.close()
        
        return path
    }
}
