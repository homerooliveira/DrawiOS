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

    func remove(drawPath: DrawPath) {
        guard let index = paths.index(where: { $0.identifier == drawPath.identifier }) else { return }
        paths.remove(at: index)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        paths.forEach { (path) in
            draw(path: path, context: context)
        }
    }
    
    func draw(path: DrawPath, context: CGContext) {
        let swatchColor = path.color
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
