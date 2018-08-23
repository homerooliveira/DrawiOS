//
//  ColorViewController.swift
//  Draw
//
//  Created by Eduardo Fornari on 21/08/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let colorView = UIColorView()
        view.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: colorView.frame.size.height),
            colorView.widthAnchor.constraint(equalToConstant: colorView.frame.size.width)
            ])
        colorView.show()
        view.sizeToFit()
        preferredContentSize = view.frame.size

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
