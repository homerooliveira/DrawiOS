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
    var selectedAction: DrawActions = DrawActions.write {
        didSet {
            canvasView.currentAction = selectedAction
        }
    }

    // MARK: - Init

    init(frame: CGRect, room: Room) {
        super.init(frame: frame)
        self.room = room
        canvasView.room = room
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }

    // MARK: - Configure View

    func configureView() {
        addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            canvasView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            canvasView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            canvasView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
            ])
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

    func changeColor(to color: UIColor) {
        canvasView.selectedColor = color
    }

}
