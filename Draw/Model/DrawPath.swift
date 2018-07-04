//
//  DrawPath.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

struct DrawPath {
    var isCompleted: Bool
    var color: String
    var points: [DrawPoint]
}

@property BOOL completed;   // Set to YES once the user stops drawing this particular line
@property NSString *color;  // The name of the color that this path is drawn in
@property RLMArray<DrawPoint *><DrawPoint> *points;

@property (readonly) UIBezierPath *path;
