//
//  GraphView.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/22/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import UIKit

class GraphView: UIView {

    private struct Constant {
        static let margin: CGFloat = 10.0
        static let topBorder: CGFloat = 50
        static let bottomBorder: CGFloat = 50
        static let countHorizontalLine = 6
    }

    override func draw(_ rect: CGRect) {

        let graphWidth = rect.width - 2 * Constant.margin
        let graphHeight = rect.height - Constant.topBorder - Constant.bottomBorder

        makeGraphs(for: graphData[0], graphWidth, graphHeight)
        drawAxisLines(rect.height, graphWidth)
    }

    private func makeGraphs(for lines: GraphArray, _ graphWidth: CGFloat, _ graphHeight: CGFloat) {
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

    private func drawAxisLines(_ viewHeight: CGFloat, _ graphWidth: CGFloat) {
        let maxXCoordinate = Constant.margin + graphWidth
        let spacingCount = Constant.countHorizontalLine

        let maxYPoint = graphData[0].lines[0].points.max()!
        let spacingPoint = maxYPoint / spacingCount

        var spacingPointsArray = [Int]()

        var yPoints = spacingPoint
        for _ in 0..<spacingCount {
            spacingPointsArray.append(yPoints)
            yPoints += spacingPoint
        }

        spacingPointsArray.forEach {
            let spacingCoordinate = CGFloat($0) * (viewHeight / CGFloat(maxYPoint))
            let horizontalLine = UIBezierPath()
            horizontalLine.move(to: CGPoint(x: Constant.margin, y: spacingCoordinate))
            horizontalLine.addLine(to: CGPoint(x: maxXCoordinate, y: spacingCoordinate))

            let color = UIColor.lightGray
            color.setStroke()

            horizontalLine.lineWidth = 1.5
            horizontalLine.stroke(with: .normal, alpha: 0.2)
        }
    }

}
