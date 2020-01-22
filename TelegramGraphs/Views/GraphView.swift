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
        let width = rect.width
        let margin = Constant.margin
        let graphWidth = width - 2 * margin

        let columnXPoint = {
            (column: Float) -> CGFloat in
            let spacing = graphWidth / CGFloat(self.graphPoints.count-1)
            return CGFloat(column) * spacing + margin
        }

        let height = rect.height
        let graphHeight = height - Constant.topBorder - Constant.bottomBorder
        let maxValue = graphPoints.max()!

        let columnYPoint = {
            (graphPoint: Float) -> CGFloat in
            let y = CGFloat(graphPoint) * (graphHeight / CGFloat(maxValue))
            return graphHeight + Constant.topBorder - y
        }

        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))

        for (index, value) in graphPoints.enumerated() {
            let nextPoint = CGPoint(x: columnXPoint(Float(index)), y: columnYPoint(value))
            graphPath.addLine(to: nextPoint)
        }

        graphPath.lineWidth = 2

        let color = UIColor.red
        color.setStroke()
        graphPath.stroke()
    }

}
