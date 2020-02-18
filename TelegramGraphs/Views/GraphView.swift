//
//  GraphView.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/22/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import UIKit

struct Constant {
    static let margin: CGFloat = 10.0
    static let topBorder: CGFloat = 20
    static let bottomBorder: CGFloat = 20
    static let countHorizontalLine = 6
    static let countXValues = 6
}

class GraphView: UIView {

    let drawer = Drawer()
    var selectedLine: Line?

    override func draw(_ rect: CGRect) {
        
        let graphWidth = rect.width - 2 * Constant.margin
        let graphHeight = rect.height - Constant.topBorder - Constant.bottomBorder
        let graph = GraphData.shared.activeGraph

        if let graph = graph {
            drawer.drawHorizontalAxis(for: graph, graphWidth, graphHeight, on: self)
            drawer.addYAxisLabel(for: graph, graphWidth, graphHeight, on: self)

            if let selectedLine = selectedLine {
                drawer.redrawLineForGraph(selectedLine, for: graph, graphWidth, graphHeight, on: self)
            } else {
                drawer.addXAxisLabel(for: graph, graphWidth, graphHeight, on: self)
                drawer.initGraph(for: graph, graphWidth, graphHeight, on: self)
            }
        } else {
            print("!!!NO GRAPH FOR DRAWING!!!")
        }

        selectedLine = nil
    }

}
