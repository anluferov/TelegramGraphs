//
//  Drawer.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 2/2/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    static let margin: CGFloat = 10.0
    static let topBorder: CGFloat = 20
    static let bottomBorder: CGFloat = 20
    static let countHorizontalLine = 6
    static let countXValues = 6
}

class Drawer {

    func makeTestGraph(on view: UIView, lineLayer: CAShapeLayer) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 100, y: 100))
        linePath.addLine(to: CGPoint(x: 400, y: 100))

        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = nil
        lineLayer.opacity = 1.0
        lineLayer.strokeColor = UIColor.blue.cgColor
        view.layer.addSublayer(lineLayer)
    }

    func redrawTestGraph(on view: UIView, lineLayer: CAShapeLayer) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 100, y: 200))
        linePath.addLine(to: CGPoint(x: 400, y: 200))

        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 1.0
        animation.fromValue = lineLayer.path
        animation.toValue = linePath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: "easeInEaseOut"))

        lineLayer.add(animation, forKey: "path")
    }

    func makeGraphs(for lines: GraphArray, _ graphWidth: CGFloat, _ graphHeight: CGFloat, lineLayer: CAShapeLayer, on view: UIView) {
        //x points
        let xPointsCount = lines.timeX.count

        let columnXPoint = {
            (column: Float) -> CGFloat in
            let spacing = graphWidth / CGFloat(xPointsCount - 1)
            return CGFloat(column) * spacing + Constant.margin
        }

        let activeGraphs = lines.lines.filter {
            $0.isHidden == false
        }

        var maxYPoint = 0
        activeGraphs.forEach {
            if $0.points.max()! > maxYPoint {
                maxYPoint = $0.points.max()!
            }
        }

        let graphPath = UIBezierPath()

        activeGraphs.forEach {
            makeSingleGraph(for: $0, with: columnXPoint, graphHeight, maxYPoint: maxYPoint, lineLayer: lineLayer, on: view, graphPath: graphPath)
        }

        if let _ = lineLayer.path {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = 1.0
            animation.fromValue = lineLayer.path
            animation.toValue = graphPath.cgPath
            lineLayer.add(animation, forKey: "path")
            lineLayer.path = graphPath.cgPath
        } else {
            lineLayer.path = graphPath.cgPath
            lineLayer.fillColor = nil
            lineLayer.opacity = 1.0
            lineLayer.lineWidth = 2
            lineLayer.strokeColor = UIColor.black.cgColor
            view.layer.addSublayer(lineLayer)
        }

    }

    private func makeSingleGraph(for line: Graph, with columnXPoint: (Float) -> CGFloat, _ graphHeight: CGFloat, maxYPoint: Int, lineLayer: CAShapeLayer, on view: UIView, graphPath: UIBezierPath) {
        //y points
        let yPoints = line.points

        let columnYPoint = {
            (yPoint: Int) -> CGFloat in
            let y = CGFloat(yPoint) * (graphHeight / CGFloat(maxYPoint))
            return graphHeight + Constant.topBorder - y
        }

        //drawing of graphs
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(yPoints[0])))

        for (index, value) in yPoints.enumerated() {
            let nextPoint = CGPoint(x: columnXPoint(Float(index)), y: columnYPoint(value))
            graphPath.addLine(to: nextPoint)
        }

//        graphPath.lineWidth = 2
//        let color = line.color!
//        color.setStroke()
//        graphPath.stroke()
    }

    func drawAxesGrid(for lines: GraphArray, _ graphWidth: CGFloat, _ graphHeight: CGFloat) {
        let maxXCoordinate = Constant.margin + graphWidth
        let spacingCount = Constant.countHorizontalLine

        let activeGraphs = lines.lines.filter {
            $0.isHidden == false
        }

        var maxYPoint = 0
        activeGraphs.forEach {
            if $0.points.max()! > maxYPoint {
                maxYPoint = $0.points.max()!
            }
        }

        let spacing = CGFloat(maxYPoint / spacingCount) * (graphHeight / CGFloat(maxYPoint))

        var yPositionArray = [CGFloat]()
        var yPosition = Constant.topBorder + graphHeight
        for _ in 0..<spacingCount {
            yPositionArray.append(yPosition)
            yPosition -= spacing
        }

        yPositionArray.forEach {
            let horizontalLine = UIBezierPath()
            horizontalLine.move(to: CGPoint(x: Constant.margin, y: $0))
            horizontalLine.addLine(to: CGPoint(x: maxXCoordinate, y: $0))

            horizontalLine.lineWidth = 1.5
            UIColor.lightGray.setStroke()
            horizontalLine.stroke(with: .normal, alpha: 0.2)
        }
    }

    func addYAxisLabel(for lines: GraphArray, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

        let spacingCount = Constant.countHorizontalLine
        let labelShiftY = CGFloat(5.0)
        let labelShiftX = CGFloat(0.0)

        let activeGraphs = lines.lines.filter {
            $0.isHidden == false
        }

        var maxYPoint = 0
        activeGraphs.forEach {
            if $0.points.max()! > maxYPoint {
                maxYPoint = $0.points.max()!
            }
        }

        let spacingInPoint = maxYPoint / spacingCount
        let spacing = CGFloat(spacingInPoint) * (graphHeight / CGFloat(maxYPoint))

        var labelInfoArray = [(yCoord: CGFloat, value: Int)]()
        var yLabelText = 0
        var yLabelPosition = Constant.topBorder + graphHeight - labelShiftY
        for _ in 0..<spacingCount {
            labelInfoArray.append((yLabelPosition,yLabelText))
            yLabelPosition -= spacing
            yLabelText += spacingInPoint
        }

        let xLabelPosition = Constant.margin + labelShiftX

        labelInfoArray.forEach {
            let yLabelWidth = CGFloat(100)
            let yLabelHeight = CGFloat(20)
            yLabelPosition = $0.yCoord - yLabelHeight
            let yLabel = UILabel(frame: CGRect(x: xLabelPosition, y: yLabelPosition, width: yLabelWidth, height: yLabelHeight))
            yLabel.text = String($0.value)
            yLabel.textColor = .lightGray
            view.addSubview(yLabel)
        }
    }

    func addXAxisLabel(for lines: GraphArray, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

        let spacingCount = Constant.countXValues
        let labelShiftY = CGFloat(5.0)
        let labelShiftX = CGFloat(5.0)

        let countXValues = lines.timeX.count
        let spacingInIndex = countXValues / spacingCount
        let spacing = CGFloat(spacingInIndex) * (graphWidth / CGFloat(countXValues))

        var labelInfoArray = [(xCoord: CGFloat, value: String)]()

        let yLabelPosition = Constant.topBorder + graphHeight + labelShiftY
        var xLabelPosition = Constant.margin + labelShiftX
        var valueIndex = 0

        for _ in 0..<spacingCount {
            let xLabelText = lines.timeX[valueIndex]
            labelInfoArray.append((xLabelPosition,xLabelText))
            xLabelPosition += spacing
            valueIndex += spacingInIndex
        }


        labelInfoArray.forEach {
            let xLabelWidth = CGFloat(100)
            let xLabelHeight = CGFloat(20)
            xLabelPosition = $0.xCoord - xLabelHeight
            let xLabel = UILabel(frame: CGRect(x: $0.xCoord, y: yLabelPosition, width: xLabelWidth, height: xLabelWidth))
            xLabel.text = $0.value
            xLabel.textColor = .lightGray
            view.addSubview(xLabel)
        }

    }
}




