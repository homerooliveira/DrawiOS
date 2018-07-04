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
        let drawView = DrawView(frame: view.bounds, room: room)
        drawView.tag = 100
        view.addSubview(drawView)
    }

    @IBAction func clearButtonAction(_ sender: UIBarButtonItem) {
        if let drawView = view.viewWithTag(100) as? DrawView {
            let alert = UIAlertController(title: "Deseja limpar a tela?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { [weak alert] (_) in
                drawView.clear()
            }))
            alert.addAction(UIAlertAction(title: "Não", style: .default, handler: { [weak alert] (_) in
            }))
            present(alert, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DatabaseAcess.shared.removeAllObservers()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

