//
//  ViewController.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/21/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var buttonsStackView: UIStackView!

    var graphToDrawInVC: Graph?

    class func instantiate(for graph: Graph) -> GraphViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GraphViewController") as! GraphViewController
        vc.graphToDrawInVC = graph
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        graphToDrawInVC!.lines.forEach {
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

    private func redrawGraphForLine(_ line: Line) {
        graphView.selectedLine = line
        graphView.setNeedsDisplay()
    }

    @objc func buttonAction(_ sender: UIButton) {

        let selectedButton = sender
        let lineName = selectedButton.titleLabel?.text
        
        let selectedLine = graphToDrawInVC!.lines.filter { $0.name == lineName }

        if let selectedLine = selectedLine.first {
            if selectedLine.isHidden {
                selectedLine.isHidden = false
                selectedButton.backgroundColor = selectedLine.color
            } else {
                selectedLine.isHidden = true
                selectedButton.backgroundColor = .lightGray
            }
            redrawGraphForLine(selectedLine)
        }
    }
}

