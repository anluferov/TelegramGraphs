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

        graphToDraw.lines.forEach {
            let button = UIButton()
            let buttonTitle = $0.name ?? "Button"
            button.setTitle(buttonTitle, for: .normal)
            button.backgroundColor = $0.color
            button.layer.cornerRadius = 20
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
            buttonsStackView.backgroundColor = .green
        }
    }

    fileprivate func redrawGraph() {
        graphView.needToRedraw = true
        graphView.setNeedsDisplay()
    }

    @objc func buttonAction(_ sender: Any) {

        let lineName = (sender as! UIButton).titleLabel?.text
        let selectedLine = graphToDraw.lines.filter { $0.name == lineName }

        if let selectedLine = selectedLine.first {
            if selectedLine.isHidden {
                selectedLine.isHidden = false
            } else {
                selectedLine.isHidden = true
            }
        }

        redrawGraph()
    }

}

