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
    private var canvasView = UICanvasView()

    private let colorView = UIColorView()

    public static let gotoDrawViewControllerIdentifier = "gotoDrawViewControllerIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView = UICanvasView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        canvasView.room = room
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(drawViewDidTapped))
        canvasView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(canvasView)

        canvasView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            canvasView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            canvasView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            canvasView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0)
            ])

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
        let alert = UIAlertController(title: "Deseja limpar a tela?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Não", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { (_) in
            self.canvasView.clear()
        }))

        present(alert, animated: true)
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
        canvasView.currentAction = .erase
    }

    @IBAction func drawButtonDidTapped(_ sender: UIBarButtonItem) {
        canvasView.currentAction = .write
    }
}

extension DrawViewController: UIColorViewDelegate {
    func colorDidChange(color: UIColor) {
        canvasView.currentColor = color
    }
}
