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

    private let colorButton = UIButton(type: .custom)
    private let clearButton = UIButton(type: .custom)
    private let drawButton = UIButton(type: .custom)
    private let eraserButton = UIButton(type: .custom)

    private let colorView = UIColorView()
    private let eraserSliderView = UISliderView()
    private let pencilSliderView = UISliderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCanvasView()
        setControls()

        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setColorView()
        setPencilSliderView()
        setEraserSliderView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DataAcess.shared.removeAllObservers()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func showNavigationBar() {
        self.navigationController?.navigationBar.alpha = 1
    }

    // MARK: - Controls

    private func setControls() {
        colorButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        colorButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        colorButton.layer.borderWidth = 1
        colorButton.layer.cornerRadius = 2
        colorButton.addTarget(self, action: #selector(colorButtonDidTapped), for: .touchUpInside)
        let colorBarButtonItem = UIBarButtonItem(customView: colorButton)
        NSLayoutConstraint.activate([
            colorButton.heightAnchor.constraint(equalToConstant: 24),
            colorButton.widthAnchor.constraint(equalToConstant: 24)
            ])

        clearButton.setImage(#imageLiteral(resourceName: "Trash"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonDidTapped), for: .touchUpInside)
        let clearBarButtonItem = UIBarButtonItem(customView: clearButton)
        NSLayoutConstraint.activate([
            clearButton.heightAnchor.constraint(equalToConstant: 24),
            clearButton.widthAnchor.constraint(equalToConstant: 24)
            ])

        drawButton.layer.cornerRadius = 2
        drawButton.setImage(#imageLiteral(resourceName: "Pencil").tint(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), for: .normal)
        drawButton.addTarget(self, action: #selector(drawButtonDidTapped), for: .touchUpInside)
        let drawBarButtonItem = UIBarButtonItem(customView: drawButton)
        NSLayoutConstraint.activate([
            drawButton.heightAnchor.constraint(equalToConstant: 24),
            drawButton.widthAnchor.constraint(equalToConstant: 24)
            ])

        eraserButton.layer.cornerRadius = 2
        eraserButton.setImage(#imageLiteral(resourceName: "Eraser"), for: .normal)
        eraserButton.addTarget(self, action: #selector(eraserButtonDidTapped(_:)), for: .touchUpInside)
        let eraserBarButtonItem = UIBarButtonItem(customView: eraserButton)
        NSLayoutConstraint.activate([
            eraserButton.heightAnchor.constraint(equalToConstant: 24),
            eraserButton.widthAnchor.constraint(equalToConstant: 24)
            ])

        navigationItem.rightBarButtonItems = [clearBarButtonItem, colorBarButtonItem,
                                              eraserBarButtonItem, drawBarButtonItem]
    }

    // MARK: - Canvas View

    private func setCanvasView() {
        canvasView = UICanvasView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        canvasView.room = room

        canvasView.delegate = self

        view.addSubview(canvasView)
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            canvasView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            canvasView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
            ])
    }

    // MARK: - Color View

    private func setColorView() {
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

    // MARK: - Eraser Slider View
    
    private func setEraserSliderView() {
        eraserSliderView.alpha = 0
        eraserSliderView.minimumValue = 10
        eraserSliderView.value = 10
        eraserSliderView.delegate = self
        view.addSubview(eraserSliderView)
        eraserSliderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eraserSliderView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            eraserSliderView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            eraserSliderView.heightAnchor.constraint(equalToConstant: eraserSliderView.frame.size.height),
            eraserSliderView.widthAnchor.constraint(equalToConstant: eraserSliderView.frame.size.width)
            ])
    }

    // MARK: - Eraser Slider View

    private func setPencilSliderView() {
        pencilSliderView.alpha = 0
        pencilSliderView.minimumValue = 1
//        pencilSliderView.maximumValue = 5
        pencilSliderView.value = 1
        pencilSliderView.delegate = self
        view.addSubview(pencilSliderView)
        pencilSliderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pencilSliderView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            pencilSliderView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            pencilSliderView.heightAnchor.constraint(equalToConstant: pencilSliderView.frame.size.height),
            pencilSliderView.widthAnchor.constraint(equalToConstant: pencilSliderView.frame.size.width)
            ])
    }

    // MARK: - Actions

    @objc func drawButtonDidTapped() {
        colorView.hide()
        eraserSliderView.hide()
        if pencilSliderView.alpha > 0 {
            pencilSliderView.hide()
        } else {
            pencilSliderView.show()
        }
        drawButton.setImage(drawButton.currentImage?.tint(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), for: .normal)
        eraserButton.setImage(eraserButton.currentImage?.tint(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), for: .normal)
        canvasView.currentAction = .write
    }

    @IBAction func eraserButtonDidTapped(_ sender: UIBarButtonItem) {
        colorView.hide()
        pencilSliderView.hide()
        if eraserSliderView.alpha > 0 {
            eraserSliderView.hide()
        } else {
            eraserSliderView.show()
        }
        drawButton.setImage(drawButton.currentImage?.tint(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), for: .normal)
        eraserButton.setImage(eraserButton.currentImage?.tint(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), for: .normal)
        canvasView.currentAction = .erase
    }

    @objc private func colorButtonDidTapped() {
        eraserSliderView.hide()
        pencilSliderView.hide()
        if colorView.alpha > 0 {
            colorView.hide()
        } else {
            colorView.show()
        }
    }

    @objc private func clearButtonDidTapped() {
        let alert = UIAlertController(title: "Deseja limpar a tela?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Não", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { (_) in
            self.canvasView.clear()
        }))
        
        present(alert, animated: true)
    }

    @objc private func viewDidDoubleTap() {
        if let navigationBar = navigationController?.navigationBar {
            if !navigationBar.isHidden {
                navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                navigationController?.setNavigationBarHidden(false, animated: false)
            }
        }
    }

}

// MARK: - UIColorViewDelegate

extension DrawViewController: UIColorViewDelegate {
    func colorDidChange(color: UIColor) {
        colorButton.backgroundColor = color
        canvasView.currentColor = color
    }
}

// MARK: - UISliderViewDelegate

extension DrawViewController: UISliderViewDelegate {
    func valueDidChange(sliderView: UISliderView) {
        if sliderView == eraserSliderView {
            canvasView.eraserSize = CGFloat(sliderView.value)
        } else {
            canvasView.pencilSize = CGFloat(sliderView.value)
        }
    }
}

// MARK: - UICanvasViewDelegate

extension DrawViewController: UICanvasViewDelegate {
    func touchesBegan() {
        colorView.hide()
        eraserSliderView.hide()
        pencilSliderView.hide()
    }
}
