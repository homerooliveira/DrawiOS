//
//  CanvasView.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

public enum DrawActions {
    case write
    case erase
}

class CanvasView: UIView {

    var room: Room?
    
    var paths: [DrawPath] = []
    
    var currentAction = DrawActions.write
    var selectedColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // Black's default color

    var lastPoint: CGPoint?

    var drawPathViewModel: DrawPathViewModel?
    

    let eraserView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backgroundColor = .white

        drawPathViewModel = DrawPathViewModel(room: room!)

        if let rooID = room?.identifier, let drawPathViewModel = drawPathViewModel {
            drawPathViewModel.fetchDrawPathAddedObservable(for: rooID) { (drawPath) in
                DispatchQueue.main.async {
                    if let drawPath = drawPath {
                        self.setNeedsDisplay()
                        self.add(drawPath: drawPath)
                        self.setNeedsDisplay()
                    }
                }
            }
            
            drawPathViewModel.fetchDrawPathRemovedObservable(for: rooID) { (drawPath) in
                DispatchQueue.main.async {
                    if let drawPath = drawPath {
                        self.setNeedsDisplay()
                        self.remove(drawPath: drawPath)
                        self.setNeedsDisplay()
                    }
                }
            }
        }

        setEraserView()
    }

    func setEraserView() {
        eraserView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        eraserView.isHidden = true
        eraserView.layer.borderWidth = 1
        eraserView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addSubview(eraserView)
    }

    func updateEraserViewPosition(to point: CGPoint) {
        eraserView.isHidden = false
        let halfEraserViewSize = eraserView.frame.size.height * 0.5
        eraserView.frame.origin.x = point.x - halfEraserViewSize
        eraserView.frame.origin.y = point.y - halfEraserViewSize
    }
    
    func hideEraserView() {
        eraserView.isHidden = true
    }

    func add(drawPath: DrawPath) {
        paths.append(drawPath)
    }

    func remove(drawPath: DrawPath) {
        guard let index = paths.index(where: { $0.identifier == drawPath.identifier }) else { return }
        paths.remove(at: index)
    }

    func erase() {
        if let drawPath = paths.first(where: { (drawPath) -> Bool in eraserView.frame.contains(drawPath.path.currentPoint) }) {
            if let drawPathViewModel = drawPathViewModel {
                drawPathViewModel.delete(with: drawPath.identifier!) { (error) in
                    if error != nil {
                        self.paths.append(drawPath)
                        self.setNeedsDisplay()
                    }
                }
                remove(drawPath: drawPath)
                setNeedsDisplay()
            }
        }
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
    
    func clear() {
        if let drawPathViewModel = drawPathViewModel {
            for drawPath in paths {
                drawPathViewModel.delete(with: drawPath.identifier!) { (error) in
                    if error == nil {
                        self.remove(drawPath: drawPath)
                    }
                }
            }
        }
    }

    // MARK: - Touch events

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else { return }
        let point = touchLocation.location(in: self)
        if currentAction == .write {
            lastPoint = point
        } else if currentAction == .erase {
            updateEraserViewPosition(to: point)
            erase()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else { return }
        let point = touchLocation.location(in: self)

        if currentAction == .write {
            if let lastPoint = lastPoint {
                if let roomID = room?.identifier {
                    if let drawPathViewModel = drawPathViewModel {
                        let drawPath = DrawPath(color: selectedColor, point1: lastPoint, point2: point, roomID: roomID)
                        drawPathViewModel.save(with: drawPath) { (error) in }
                        add(drawPath: drawPath)
                        setNeedsDisplay()
                    }
                }
            }
            lastPoint = point
        } else if currentAction == .erase {
            updateEraserViewPosition(to: point)
            erase()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else { return }
        let point = touchLocation.location(in: self)

        if currentAction == .write {
            if let lastPoint = lastPoint {
                if let roomID = room?.identifier {
                    if let drawPathViewModel = drawPathViewModel {
                        let drawPath = DrawPath(color: selectedColor, point1: lastPoint, point2: point, roomID: roomID)
                        drawPathViewModel.save(with: drawPath) { (error) in }
                        add(drawPath: drawPath)
                        setNeedsDisplay()
                    }
                }
            }
            lastPoint = point
        } else if currentAction == .erase {
            updateEraserViewPosition(to: point)
            erase()
            hideEraserView()
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
