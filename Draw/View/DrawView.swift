//
//  DrawView.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var canvasView = CanvasView(frame: .zero)
    var room: Room!

    var lastPoint: CGPoint?
    var selectedColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    init(frame: CGRect, room: Room) {
        super.init(frame: frame)
        self.room = room
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    func configureView() {
        addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            canvasView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            canvasView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            canvasView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
            ])

        DatabaseAcess.shared.fetchDrawPathAddedObservable(for: room.identifier!) { (drawPath) in
            DispatchQueue.main.async {
                if let drawPath = drawPath {
                    self.canvasView.setNeedsDisplay()
                    self.canvasView.add(drawPath: drawPath)
                    self.canvasView.setNeedsDisplay()
                }
            }
        }

        DatabaseAcess.shared.fetchDrawPathRemovedObservable(for: room.identifier!) { (drawPath) in
            DispatchQueue.main.async {
                if let drawPath = drawPath {
                    self.canvasView.setNeedsDisplay()
                    self.canvasView.remove(drawPath: drawPath)
                    self.canvasView.setNeedsDisplay()
                }
            }
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxDimension = max(bounds.width, bounds.height)
        var frame = canvasView.frame
        frame.size.width = maxDimension
        frame.size.height = maxDimension
        frame.origin.x = (bounds.width - maxDimension) * 0.5
        canvasView.frame = frame
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else { return }
        lastPoint = touchLocation.location(in: canvasView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else { return }
        let point = touchLocation.location(in: canvasView)

        if let lastPoint = lastPoint {
            let drawPath = DrawPath(color: selectedColor, point1: lastPoint, point2: point, roomID: room.identifier!)
            DatabaseAcess.shared.save(with: drawPath) { (error) in }
            canvasView.add(drawPath: drawPath)
            canvasView.setNeedsDisplay()
        }

        lastPoint = point
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else { return }
        let point = touchLocation.location(in: canvasView)

        if let lastPoint = lastPoint {
            let drawPath = DrawPath(color: selectedColor, point1: lastPoint, point2: point, roomID: room.identifier!)
            DatabaseAcess.shared.save(with: drawPath) { (error) in }
            canvasView.add(drawPath: drawPath)
            canvasView.setNeedsDisplay()
        }
        
        lastPoint = point
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    func clear(){
        DatabaseAcess.shared.deleteAllDrawPaths(with: room.identifier ?? "", completion: { [weak self] _ in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.canvasView.setNeedsDisplay()
                strongSelf.canvasView.paths = []
                strongSelf.canvasView.clearCanvas()
                strongSelf.canvasView.setNeedsDisplay()
            }
        })
    }
}
