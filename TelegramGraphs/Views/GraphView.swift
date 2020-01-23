//
//  GraphView.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/22/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import UIKit

class GraphView: UIView {

    @IBInspectable var lainColor: UIColor = .green
    private struct Constant {
        static let margin: CGFloat = 0.0
        static let topBorder: CGFloat = 50
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 1
    }

    override func draw(_ rect: CGRect) {

        let graphWidth = rect.width - 2 * Constant.margin
        let graphHeight = rect.height - Constant.topBorder - Constant.bottomBorder

        makeGraphs(for: graphData[3], graphWidth, graphHeight)
    }

    func makeGraphs(for lines: GraphArray, _ graphWidth: CGFloat, _ graphHeight: CGFloat) {
        //x points
        let xPointsCount = lines.timeX.count

        let columnXPoint = {
            (column: Float) -> CGFloat in
            let spacing = graphWidth / CGFloat(xPointsCount - 1)
            return CGFloat(column) * spacing + Constant.margin
        }

        lines.lines.forEach {
            makeSingleGraph(for: $0, with: columnXPoint, graphHeight)
        }
    }

    private func makeSingleGraph(for line: Graph, with columnXPoint: (Float) -> CGFloat, _ graphHeight: CGFloat) {
        //y points
        let yPoints = line.points
        let maxYPoint = line.points.max()!

        let columnYPoint = {
            (yPoint: Int) -> CGFloat in
            let y = CGFloat(yPoint) * (graphHeight / CGFloat(maxYPoint))
            return graphHeight + Constant.topBorder - y
        }

        //drawing of graphs
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(yPoints[0])))

        for (index, value) in yPoints.enumerated() {
            let nextPoint = CGPoint(x: columnXPoint(Float(index)), y: columnYPoint(value))
            graphPath.addLine(to: nextPoint)
        }

        graphPath.lineWidth = 2

        let color = line.color!
        color.setStroke()
        graphPath.stroke()
    }

}
