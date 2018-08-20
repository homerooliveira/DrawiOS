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

    private let colorView = UIColorView()

    public static let gotoDrawViewControllerIdentifier = "gotoDrawViewControllerIdentifier"

    private var drawView: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView = DrawView(frame: view.bounds, room: room)
        drawView.tag = 100
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(drawViewDidTapped))
        drawView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(drawView)

        colorView.alpha = 0
        colorView.delegate = self
        view.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            colorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            colorView.heightAnchor.constraint(equalToConstant: colorView.frame.size.height),
            colorView.widthAnchor.constraint(equalToConstant: colorView.frame.size.width)
            ])
    }

    @IBAction func clearButtonAction(_ sender: UIBarButtonItem) {
        if let drawView = view.viewWithTag(100) as? DrawView {
            let alert = UIAlertController(title: "Deseja limpar a tela?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { [weak alert] (_) in
                drawView.canvasView.clear()
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

    @IBAction func selectColorAction(_ sender: UIBarButtonItem) {
        if colorView.alpha > 0 {
            colorView.hide()
        } else {
            colorView.show()
        }
    }

    @objc private func drawViewDidTapped() {
        colorView.hide()
    }

    @IBAction func eraserButtonDidTapped(_ sender: UIBarButtonItem) {
        drawView.selectedAction = .erase
    }

    @IBAction func drawButtonDidTapped(_ sender: UIBarButtonItem) {
        drawView.selectedAction = .write
    }
}

extension DrawViewController: UIColorViewDelegate {
    func colorDidChange(color: UIColor) {
        drawView.changeColor(to: color)
    }
}
