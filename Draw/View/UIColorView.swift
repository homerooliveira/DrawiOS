//
//  UIColorView.swift
//  Draw
//
//  Created by Eduardo Fornari on 16/08/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

class UIColorView: UIView {

    var delegate: UIColorViewDelegate?

    var selectedColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // Default color
    var indexSelectedColor: Int?

    private var margin: CGFloat = 0.0

    private let hideShowAnimationDuration = 0.5

    let collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewFlowLayout())
    private var collectionViewCellSize: CGFloat = 0.0
    let colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                  #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1),
                  #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1),
                  #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),
                  #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
                  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
                  #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),
                  #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]

    let colorPickerView = UIColorPickerView(frame: .zero)
    let colorPickerSelectetColorView = UIView(frame: .zero)

    let segmentedControl = UISegmentedControl(items: ["Colors", "Custom"])

    // MARK: - Init

    init() {
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        let smallerSize = screenHeight < screenWidth ? screenHeight : screenWidth
        let height = smallerSize * 0.9
        margin = height * 0.02
        collectionViewCellSize = (height - (10 * margin) - segmentedControl.frame.size.height) / 8
        let width = (collectionViewCellSize * 6) + margin * 7

        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        super.init(frame: frame)

        layer.cornerRadius = width * 0.02
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        clipsToBounds = true

        setBlurView()
        setControls()
        setCollectionView()
        alpha = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setBlurView() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            blurView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            blurView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
            ])
    }

    private func setCollectionView() {
        addSubview(collectionView)

        indexSelectedColor = colors.index(where: { (color) -> Bool in color == selectedColor })

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = margin
            layout.minimumInteritemSpacing = margin
            layout.sectionInset.top = margin
            layout.sectionInset.right = margin
            layout.sectionInset.bottom = margin
            layout.sectionInset.left = margin
            layout.itemSize = CGSize(width: collectionViewCellSize, height: collectionViewCellSize)
        }
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            ])
        collectionView.delegate = self
        collectionView.dataSource = self

        updateCellsScale()
    }

    private func setColorPickerView() {
        let colorPickerViewHeight =
            frame.size.height - segmentedControl.frame.size.height - 4 * margin
        let colorPickerViewWidth = colorPickerViewHeight * 0.75
        let colorPickerViewFrame = CGRect(x: 0, y: 0, width: colorPickerViewWidth, height: colorPickerViewHeight)

        colorPickerSelectetColorView.frame = segmentedControl.frame
        colorPickerSelectetColorView.backgroundColor = selectedColor
        colorPickerSelectetColorView.layer.cornerRadius = colorPickerViewFrame.width * 0.02
        colorPickerSelectetColorView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        colorPickerSelectetColorView.layer.borderWidth = 1
        addSubview(colorPickerSelectetColorView)
        colorPickerSelectetColorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorPickerSelectetColorView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: margin),
            colorPickerSelectetColorView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            colorPickerSelectetColorView.heightAnchor.constraint(equalToConstant: colorPickerSelectetColorView.frame.size.height),
            colorPickerSelectetColorView.widthAnchor.constraint(equalToConstant: colorPickerViewFrame.size.width)
            ])

        addSubview(colorPickerView)
        colorPickerView.delegate = self
        colorPickerView.frame = colorPickerViewFrame
        colorPickerView.layer.cornerRadius = colorPickerSelectetColorView.layer.cornerRadius
        colorPickerView.layer.borderColor = colorPickerSelectetColorView.layer.borderColor
        colorPickerView.layer.borderWidth = colorPickerSelectetColorView.layer.borderWidth
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorPickerView.widthAnchor.constraint(equalToConstant: colorPickerViewFrame.width),
            colorPickerView.topAnchor.constraint(equalTo: colorPickerSelectetColorView.bottomAnchor, constant: margin),
            colorPickerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            colorPickerView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
    }

    private func setControls() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }

    @objc private func segmentedControlValueChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            colorPickerView.removeFromSuperview()
            colorPickerSelectetColorView.removeFromSuperview()
            setCollectionView()
        } else {
            collectionView.removeFromSuperview()
            setColorPickerView()
        }
    }

    @objc private func selectedColorDidChange() {
        if let delegate = delegate {
            delegate.colorDidChange(color: selectedColor)
        }
    }

    public func show() {
        indexSelectedColor = colors.index(where: { (color) -> Bool in color == selectedColor })
        collectionView.reloadData()
        UIView.animate(withDuration: hideShowAnimationDuration) {
            self.alpha = 1
        }
    }

    public func hide() {
        UIView.animate(withDuration: hideShowAnimationDuration) {
            self.alpha = 0
        }
    }
}

// MARK: - UIColorViewDelegate

protocol UIColorViewDelegate {
    func colorDidChange(color: UIColor)
}

// MARK: - UIColorView

extension UIColorView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
        let color = colors[indexPath.row]
        cell.backgroundColor = color
        if color == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = layer.borderColor
        }
        cell.layer.cornerRadius = 2
        cell.contentView.layer.masksToBounds = true

        updateCellsScale()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colors[indexPath.row]
        indexSelectedColor = indexPath.row
        updateCellsScale()
        selectedColorDidChange()
        
    }

    // MARK: - Update Cells Scale

    internal func updateCellsScale() {
        for colorCell in collectionView.visibleCells {
            resetScale(cell: colorCell)
            if let indexPath = collectionView.indexPath(for: colorCell) {
                if let indexSelectedColor = indexSelectedColor {
                    if indexSelectedColor == indexPath.row {
                        upScale(cell: colorCell)
                    }
                }
            }
        }
    }

    // MARK: - Up Scale
    
    private func upScale(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0, animations: {
            let newScale: CGFloat = 1.3
            cell.transform = CGAffineTransform(scaleX: newScale, y: newScale)
            cell.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 0.8
            cell.layer.shadowOpacity = 1
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        })
    }
    
    // MARK: - Reset Cell
    
    private func resetScale(cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0, animations: {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        })
    }
}

extension UIColorView: UIColorPickerViewDelegate {
    func colorColorPickerTouched(sender: UIColorPickerView, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        colorPickerSelectetColorView.backgroundColor = color
        selectedColor = color
        selectedColorDidChange()
    }
}
