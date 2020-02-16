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
    let lineLayer = CAShapeLayer()
    var needToRedraw = false

    override func draw(_ rect: CGRect) {

        let graphWidth = rect.width - 2 * Constant.margin
        let graphHeight = rect.height - Constant.topBorder - Constant.bottomBorder
        let graph = graphsArray[0]

        drawer.drawHorizontalAxes(for: graph, graphWidth, graphHeight, on: self)
//        drawer.addYAxisLabel(for: graphArray, graphWidth, graphHeight, on: self)
//        drawer.addXAxisLabel(for: graphArray, graphWidth, graphHeight, on: self)


        if !needToRedraw {
            drawer.initGraph(for: graph, graphWidth, graphHeight, on: self)
        } else {
            drawer.redrawGraph(for: graph, graphWidth, graphHeight, on: self)
        }

    }

}
