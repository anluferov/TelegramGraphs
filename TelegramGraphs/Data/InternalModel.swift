//
//  InternalModel.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 2/16/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Interanl format of graph data

// Model of array of graphs (lines and X points)
struct Graph {
    var nameX: String? //name of dX from JSON
    var timeX = [String]() //attribute on dX from JSON
    var colorX: UIColor? //color from JSON
    var lines = [Line]() //array of lines on final graph
}


// Model of one line in graph (Y points) and its attributes
struct Line {
    var layerIndex: Int = 0 //custom ordinal id in Layers Array
    var name: String? //name from JSON
    var type: String? //type from JSON
    var color: UIColor? //color from JSON
    var isHidden: Bool = false //custom attribute. determine to shown line or not
    var points = [Int]() //array of Y points from JSON
    var countY = 0 //number of Y points
}
