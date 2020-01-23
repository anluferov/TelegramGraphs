//
//  ViewController.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/21/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let dataConverter = DataConverter()

    override func viewDidLoad() {
        super.viewDidLoad()

        let graphJSOONData = dataConverter.getDataFromJSON(withName: "chart_data")
        let graphData = graphJSOONData.map {
            dataConverter.convertIntoInternalFormat(from: $0)
        }

        print(graphData)
    }



}

