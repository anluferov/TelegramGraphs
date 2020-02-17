//
//  ViewController.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/21/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        graphs[0].lines.forEach {
//            let button = UIButton()
//            let buttonTitle = $0.name ?? "Button"
//            button.setTitle(buttonTitle, for: .normal)
////            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//            buttonsStackView.addArrangedSubview(button)
//            buttonsStackView.backgroundColor = .green
//        }

        buttonsStackView.backgroundColor = .black

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buttonsStackView.backgroundColor = .yellow
    }

    @IBAction func buttonAction(_ sender: Any) {

        if graphs[0].lines[0].isHidden  {
            graphs[0].lines[0].isHidden = false
        }  else {
            graphs[0].lines[0].isHidden = true
        }

        graphView.needToRedraw = true
        
        graphView.setNeedsDisplay()
    }

}

