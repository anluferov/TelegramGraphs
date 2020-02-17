//
//  Data.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 2/17/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import Foundation

class GraphData {

    static let shared = GraphData()

    //data with graph info from json in internal format
    var graphs = GraphConverter().convertIntoInternalFormatFromJson(withName: "chart_data")

    //array of VC for pageVC with all graphs
    lazy var viewControllersWithDifferentGraphs = graphs.map {
        GraphViewController.instantiate(for: $0)
    }

    //graph which is displayed on screen now
    var activeGraph: Graph?
}


