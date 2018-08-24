//
//  UISliderView.swift
//  Draw
//
//  Created by Eduardo Fornari on 22/08/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

class UISliderView: UIView {

    var delegate: UISliderViewDelegate?

    private var margin: CGFloat = 0.0

    private let hideShowAnimationDuration = 0.5

    var value: Float = 1 {
        didSet {
            slider.value = value
        }
    }
    var minimumValue: Float! {
        didSet {
            slider.minimumValue = minimumValue
        }
    }
    var maximumValue: Float! {
        didSet {
            slider.maximumValue = maximumValue
        }
    }

    let slider = UISlider(frame: .zero)

    // MARK: - Init
    
    init() {
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        let smallerSize = screenHeight < screenWidth ? screenHeight : screenWidth
        let width = smallerSize * 0.5
        margin = width * 0.02

        slider.minimumValue = value
        slider.value = value
        slider.maximumValue = Float(smallerSize * 0.5)
        slider.sizeToFit()

        let height = slider.frame.size.height + (2 * margin)
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        super.init(frame: frame)
        
        addSubview(slider)
        slider.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            slider.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            slider.leftAnchor.constraint(equalTo: leftAnchor, constant: margin)
            ])
        
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.cornerRadius = width * 0.02

        setShadow()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Shadow
    
    private func setShadow() {
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0.8
        layer.shadowOpacity = 1
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    // MARK: - Show
    
    public func show() {
        UIView.animate(withDuration: hideShowAnimationDuration) {
            self.alpha = 1
        }
    }
    
    // MARK: - Hide
    
    public func hide() {
        UIView.animate(withDuration: hideShowAnimationDuration) {
            self.alpha = 0
        }
    }

    // MARK: - Collor Did Change
    
    @objc private func valueDidChange() {
        if let delegate = delegate {
            value = slider.value
            delegate.valueDidChange(sliderView: self)
        }
    }

}

// MARK: - UIColorViewDelegate

protocol UISliderViewDelegate {
    func valueDidChange(sliderView: UISliderView)
}


