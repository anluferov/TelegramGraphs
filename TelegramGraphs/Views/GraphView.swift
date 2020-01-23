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
    private var graphPoints: [Float] = [0.0,0.0,0.0,0.0,25,0,25.0,17.0,17.0,22.0,22.0,0.0,15.0,15.0,0.0,0.0,0.0]
    private var circleLayer: CAShapeLayer!

    override func draw(_ rect: CGRect) {

        //x points
        let width = rect.width
        let margin = Constant.margin
        let graphWidth = width - 2 * Constant.margin

        let xPointsCount = graphData[0].timeX.count

        let columnXPoint = {
            (column: Float) -> CGFloat in
            let spacing = graphWidth / CGFloat(xPointsCount - 1)
            return CGFloat(column) * spacing + margin
        }
        
        // y points
        let height = rect.height
        let topBorder = Constant.topBorder
        let bottomBorder = Constant.bottomBorder
        let graphHeight = height - topBorder - bottomBorder

        let yPoints = graphData[0].lines[0].points
        let maxYPoint = graphData[0].lines[0].points.max()!

        let columnYPoint = {
            (yPoint: Int) -> CGFloat in
            let y = CGFloat(yPoint) * (graphHeight / CGFloat(maxYPoint))
            return graphHeight + topBorder - y
        }

        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(yPoints[0])))

        for (index, value) in yPoints.enumerated() {
            let nextPoint = CGPoint(x: columnXPoint(Float(index)), y: columnYPoint(value))
            graphPath.addLine(to: nextPoint)
        }

        graphPath.lineWidth = 2

        let color = graphData[0].lines[0].color!
        color.setStroke()
        graphPath.stroke()
    }

}
