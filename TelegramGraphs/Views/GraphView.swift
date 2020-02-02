//
//  GraphView.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/22/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import UIKit

class GraphView: UIView {

    let drawer = Drawer()
    let lineLayer = CAShapeLayer()
    var needToRedraw = false

    override func draw(_ rect: CGRect) {

        let graphWidth = rect.width - 2 * Constant.margin
        let graphHeight = rect.height - Constant.topBorder - Constant.bottomBorder
        let graphArray = graphData[0]

        drawer.drawAxesGrid(for: graphArray, graphWidth, graphHeight)
        drawer.addYAxisLabel(for: graphArray, graphWidth, graphHeight, on: self)
        drawer.addXAxisLabel(for: graphArray, graphWidth, graphHeight, on: self)

        drawer.makeGraphs(for: graphArray, graphWidth, graphHeight, lineLayer: lineLayer, on: self)

//        if !needToRedraw {
//            drawer.makeTestGraph(on: self, lineLayer: lineLayer)
//        } else {
//            drawer.redrawTestGraph(on: self, lineLayer: lineLayer)
//        }

    }

}
