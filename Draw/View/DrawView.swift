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
    var drawPath = DrawPath(id: UUID().uuidString, isCompleted: false, color: "black", points: [])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        DatabaseAcess.share.changes { (paths) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                if paths.isEmpty {
                    strongSelf.canvasView.clearCanvas()
                } else {
                    strongSelf.canvasView.paths = paths
                    strongSelf.canvasView.setNeedsDisplay()
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
        
        drawPath.points.append(point)
        
        DatabaseAcess.share.save(drawPath)
        canvasView.setNeedsDisplay()
    }
    
    func add(point: CGPoint) {
        drawPath.points.append(point)
        DatabaseAcess.share.save(drawPath)
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
        
        drawPath = DrawPath(id: UUID().uuidString,isCompleted: false, color: "black", points: [])
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
    }
}
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reset Canvas?"
//        message:@"This will clear the Realm database and reset the canvas. Are you sure you wish to proceed?"
//        preferredStyle:UIAlertControllerStyleAlert];
//
//    typeof(self) __weak weakSelf = self;
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Reset"
//        style:UIAlertActionStyleDefault
//        handler:^(UIAlertAction *action) {
//        [[RLMRealm defaultRealm] transactionWithBlock:^{
//        [[RLMRealm defaultRealm] deleteAllObjects];
//        }];
//
//        [weakSelf.canvasView clearCanvas];
//        }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
//
//    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
//}
