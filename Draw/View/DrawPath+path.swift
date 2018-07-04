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
        path.lineWidth = 4
        
        guard let first = self.points.first else { return path }
        path.move(to: first)
        let points = self.points.dropFirst()
        
        points.forEach { (point) in
            path.addLine(to: point)
        }
        
        return path
    }
}
