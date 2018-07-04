//
//  ViewController.swift
//  Draw
//
//  Created by Homero Oliveira on 03/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {

    public var room: Room!

    public static let gotoDrawViewControllerIdentifier = "gotoDrawViewControllerIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let drawView = DrawView(frame: view.bounds, room: room)
        view.addSubview(drawView)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DatabaseAcess.shared.removeAllObservers()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

