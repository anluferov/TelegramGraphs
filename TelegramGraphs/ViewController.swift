//
//  ViewController.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/21/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = Bundle.main.path(forResource: "chart_data", ofType: "json") {
            do {
                let chartDataFile = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let chartData = try JSONDecoder().decode(GraphModel.self, from: chartDataFile)

                print(chartData)
              } catch {
                   print(error)
              }
        }
    }



}

