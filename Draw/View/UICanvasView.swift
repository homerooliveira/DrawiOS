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

class UICanvasView: UIView {

    public var room: Room?

    public var currentAction = DrawActions.write
    public var currentColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // Black's default color

    private var lastPoint: CGPoint?

    private var drawPathViewModel: DrawPathViewModel?

    public var eraserSize: CGFloat = 10 {
        didSet {
            eraserView.frame.size = CGSize(width: eraserSize, height: eraserSize)
        }
    }
    public var pencilSize: CGFloat = 1
    private let eraserView = UIView(frame: .zero)
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backgroundColor = .white

        drawPathViewModel = DrawPathViewModel(room: room!)

        if let drawPathViewModel = drawPathViewModel {
            drawPathViewModel.fetchDrawPathAddedObservable { (drawPath) in
                DispatchQueue.main.async {
                    if let drawPath = drawPath {
                        self.setNeedsDisplay()
                        self.add(drawPath: drawPath)
                        self.setNeedsDisplay()
                    }
                }
            }
            
            drawPathViewModel.fetchDrawPathRemovedObservable { (drawPath) in
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

    // MARK: - Eraser View

    func setEraserView() {
        eraserView.frame.size = CGSize(width: eraserSize, height: eraserSize)
        eraserView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        eraserView.layer.borderWidth = 1
        eraserView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        eraserView.isHidden = true
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

    // MARK: - Add Path

    func add(drawPath: DrawPath) {
        drawPathViewModel?.paths.append(drawPath)
    }

    // MARK: - Remove Path

    func remove(drawPath: DrawPath) {
        if let drawPathViewModel = drawPathViewModel,
            let index = drawPathViewModel.paths.index(where: { $0.identifier == drawPath.identifier }) {

            drawPathViewModel.paths.remove(at: index)
            setNeedsDisplay()
        }
    }

    // MARK: - Erase

    func erase() {
        if let drawPathViewModel = drawPathViewModel,
            let drawPath = drawPathViewModel.paths
                .first(where: { (drawPath) -> Bool in eraserView
                    .frame.contains(drawPath.path.currentPoint) }) {
            drawPathViewModel.delete(with: drawPath.identifier!) { (error) in
                if error != nil {
                    drawPathViewModel.paths.append(drawPath)
                    self.setNeedsDisplay()
                }
            }
            remove(drawPath: drawPath)
            setNeedsDisplay()
        }
    }

    // MARK: - Clear
    
    func clear() {
        if let drawPathViewModel = drawPathViewModel {
            for drawPath in drawPathViewModel.paths {
                drawPathViewModel.delete(with: drawPath.identifier!) { (error) in
                    if error == nil {
                        self.remove(drawPath: drawPath)
                    }
                }
            }
        }
    }

    // MARK: - Draw

    override func draw(_ rect: CGRect) {
        if let drawPathViewModel = drawPathViewModel {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            drawPathViewModel.paths.forEach { (path) in
                draw(path: path, context: context)
            }
        }
    }
    
    func draw(path: DrawPath, context: CGContext) {
        let swatchColor = path.color
        context.setStrokeColor(swatchColor.cgColor)
        context.setLineWidth(path.path.lineWidth)
        context.addPath(path.path.cgPath)
        context.strokePath()
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
            if let lastPoint = lastPoint, let roomID = room?.identifier, let drawPathViewModel = drawPathViewModel {
                let drawPath = DrawPath(color: currentColor, lineWidth: pencilSize, point1: lastPoint, point2: point, roomID: roomID)
                drawPathViewModel.save(with: drawPath) { (error) in }
                add(drawPath: drawPath)
                setNeedsDisplay()
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
            if let lastPoint = lastPoint, let roomID = room?.identifier, let drawPathViewModel = drawPathViewModel {
                let drawPath = DrawPath(color: currentColor, lineWidth: pencilSize, point1: lastPoint, point2: point, roomID: roomID)
                drawPathViewModel.save(with: drawPath) { (error) in }
                add(drawPath: drawPath)
                setNeedsDisplay()
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
