//
//  CanvasView.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    var paths: [DrawPath] = []
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backgroundColor = .white
    }

    func add(drawPath: DrawPath) {
        paths.append(drawPath)
    }

    func update(drawPath: DrawPath) {
        let index = paths.index { (drawPath) -> Bool in
            drawPath.identifier == drawPath.identifier
        }
        if let indexDrawPath = index {
            paths[indexDrawPath] = drawPath
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        paths.forEach { (path) in
            draw(path: path, context: context)
        }
    }
    
    func draw(path: DrawPath, context: CGContext) {
        let swatchColor = UIColor.black
        context.setStrokeColor(swatchColor.cgColor)
        context.setLineWidth(path.path.lineWidth)
        context.addPath(path.path.cgPath)
        context.strokePath()
    }
    
    func clearCanvas() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(UIColor.white.cgColor)
        context.fill(bounds)
    }
}
