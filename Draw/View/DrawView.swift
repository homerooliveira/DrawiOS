//
//  DrawView.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var canvasView: CanvasView!
    var room: Room!
    var drawPath: DrawPath!
    
    init(frame: CGRect, room: Room) {
        super.init(frame: frame)
        self.room = room
        drawPath = DrawPath(identifier: UUID().uuidString, isCompleted: false, color: "black", points: [], roomID: room.identifier!)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    func configureView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        canvasView = CanvasView(frame: .zero)
        addSubview(canvasView)

        DatabaseAcess.shared.fetchDrawPathsObservable(for: room.identifier!) { (paths) in
            if let paths = paths {
                if paths.isEmpty {
                    self.canvasView.clearCanvas()
                } else {
                    self.canvasView.paths = paths
                    self.canvasView.setNeedsDisplay()
                }
            }
        }
        
        becomeFirstResponder()
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
        let point = touchLocation.location(in: canvasView)
        
        add(point: point)
        
        DatabaseAcess.shared.save(with: drawPath) { (error) in }
        canvasView.add(drawPath: drawPath)
        canvasView.setNeedsDisplay()
    }
    
    func add(point: CGPoint) {
        drawPath.points.append(point)
        DatabaseAcess.shared.save(with: drawPath) { (error) in }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else { return }
        let point = touchLocation.location(in: canvasView)
        
        add(point: point)
        canvasView.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else { return }
        let point = touchLocation.location(in: canvasView)
        
        add(point: point)
        
        drawPath = DrawPath(identifier: UUID().uuidString, isCompleted: false, color: "black", points: [], roomID: room.identifier!)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    func clear(){
        DatabaseAcess.shared.deleteAllDrawPaths(with: room.identifier ?? "", completion: { [weak self] _ in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.canvasView.paths = []
                strongSelf.canvasView.clearCanvas()
            }
        })
    }
}
