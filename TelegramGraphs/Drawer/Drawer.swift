//
//  Drawer.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 2/2/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import Foundation
import UIKit

class Drawer {

    let animator = Animator()

    //array of CAShapeLayers. Each CAShapeLayer will contain a line or axes
    var imagesLayers = [CAShapeLayer]()

    //CAShapeLayer for horizontal lines
    let horizontalAxesLayer = CAShapeLayer()

    enum linesType {
        case all
        case hidden
        case notHidden
    }

    private func getLines(from lines: Graph, type: linesType) -> [Line] {
        let allLines = lines.lines
        switch type {
        case .hidden:
            return allLines.filter { $0.isHidden == true }
        case .notHidden:
            return allLines.filter { $0.isHidden == false }
        case .all:
            return allLines
        }
    }

    private func getMaxYPoint(for lines: [Line]) -> Int {
        var maxYPoint = 0
        lines.forEach {
            if $0.points.max()! > maxYPoint {
                maxYPoint = $0.points.max()!
            }
        }
        return maxYPoint
    }

    //MARK: - drawing of graphs based on array of lines

    // Function for initial drawing graph with all not hidden lines on view
    func initGraph(for graph: Graph, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

        //filter not hidden graphs for drawing
        let notHiddenLines = getLines(from: graph, type: .notHidden)

        //calculation position of X points
        let xPointsCount = graph.timeX.count
        let columnXPoint = {
            (column: Float) -> CGFloat in
            let spacing = graphWidth / CGFloat(xPointsCount - 1)
            return CGFloat(column) * spacing + Constant.margin
        }

        //calculate max Y point for all not hidden lines in graph
        let maxYPoint = getMaxYPoint(for: notHiddenLines)

        notHiddenLines.forEach {
            //calculation position of Y points
            let yPoints = $0.points
            let columnYPoint = {
                (yPoint: Int) -> CGFloat in
                let y = CGFloat(yPoint) * (graphHeight / CGFloat(maxYPoint))
                return graphHeight + Constant.topBorder - y
            }

            //drawing all lines in graph with UIBezierPath
            let graphPath = UIBezierPath()
            graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(yPoints[0])))
            for (index, value) in yPoints.enumerated() {
                let nextPoint = CGPoint(x: columnXPoint(Float(index)), y: columnYPoint(value))
                graphPath.addLine(to: nextPoint)
            }

            //create CAShapeLayer for line and set line in path of layer
            let graphLayer = CAShapeLayer()
            graphLayer.path = graphPath.cgPath
            graphLayer.strokeColor = $0.color?.cgColor
            graphLayer.lineWidth = 2.0
            graphLayer.fillColor = nil
            graphLayer.opacity = 1.0

            //insert layer with a line to array with all lines on layerId position
            imagesLayers.insert(graphLayer, at: $0.layerIndex)
            //add layer with line on view
            view.layer.addSublayer(imagesLayers[$0.layerIndex])
        }
    }

    func redrawGraph(for graph: Graph, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

        //filter hidden and not hidden graphs for drawing
        let notHiddenLines = getLines(from: graph, type: .notHidden)
        let hiddenLines = getLines(from: graph, type: .hidden)

        //calculation position of X points
        let xPointsCount = graph.timeX.count
        let columnXPoint = {
            (column: Float) -> CGFloat in
            let spacing = graphWidth / CGFloat(xPointsCount - 1)
            return CGFloat(column) * spacing + Constant.margin
        }

        //calculate max Y point for all not hidden lines in graph
        let maxYPoint = getMaxYPoint(for: notHiddenLines)

        //redraw with animation all changes for not hidden lines
        notHiddenLines.forEach {
            //calculation position of Y points
            let yPoints = $0.points
            let columnYPoint = {
                (yPoint: Int) -> CGFloat in
                let y = CGFloat(yPoint) * (graphHeight / CGFloat(maxYPoint))
                return graphHeight + Constant.topBorder - y
            }

            //drawing all lines in graph with UIBezierPath
            let graphPath = UIBezierPath()
            graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(yPoints[0])))
            for (index, value) in yPoints.enumerated() {
                let nextPoint = CGPoint(x: columnXPoint(Float(index)), y: columnYPoint(value))
                graphPath.addLine(to: nextPoint)
            }

            if let subLayer = imagesLayers[safe: $0.layerIndex], let subLayerPath = subLayer.path {
                animator.animateChangingPath(from: subLayerPath, to: graphPath.cgPath, on: subLayer)
                subLayer.path = graphPath.cgPath

                //if this line was hidden, change opacity
                if subLayer.opacity == 0.0 {
                    subLayer.opacity = 1.0
                    animator.animateAppear(on: subLayer)
                }
            }
        }

        //hide all firstly hidden lines
        hiddenLines.forEach {
            if let subLayer = imagesLayers[safe: $0.layerIndex] {
                subLayer.opacity = 0.0
                animator.animateDisappear(on: subLayer)
            }

        }
    }

    //MARK: - drawing of axes
    func drawHorizontalAxes(for graph: Graph, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

        //filter hidden and not hidden graphs for drawing
        let notHiddenLines = getLines(from: graph, type: .notHidden)

        //calculate max Y point for all not hidden lines in graph
        let maxYPoint = getMaxYPoint(for: notHiddenLines)

        //create array of Y position for dX axes
        var yPositionArray = [CGFloat]()
        let ySpacing = CGFloat(maxYPoint / Constant.countHorizontalLine) * (graphHeight / CGFloat(maxYPoint))
        var yPosition = Constant.topBorder + graphHeight
        for _ in 0..<Constant.countHorizontalLine {
            yPositionArray.append(yPosition)
            yPosition -= ySpacing
        }

        //draw all horizontal lines and append their to final UIBezierPath
        let horizontalLines = UIBezierPath()
        yPositionArray.forEach {
            let horizontalLine = UIBezierPath()
            horizontalLine.move(to: CGPoint(x: Constant.margin, y: $0))
            horizontalLine.addLine(to: CGPoint(x: Constant.margin + graphWidth, y: $0))
            horizontalLines.append(horizontalLine)
        }

        //set layer for horizontal lines grid
        horizontalAxesLayer.strokeColor = UIColor.lightGray.cgColor
        horizontalAxesLayer.lineWidth = 1.5
        horizontalAxesLayer.fillColor = nil
        horizontalAxesLayer.opacity = 0.8
        if let oldPath = horizontalAxesLayer.path {
            animator.animateChangingPath(from: oldPath, to: horizontalLines.cgPath, on: horizontalAxesLayer)
            horizontalAxesLayer.path = horizontalLines.cgPath
        } else {
            horizontalAxesLayer.path = horizontalLines.cgPath

            //add layer with grid to array of layers and on view
            imagesLayers.append(horizontalAxesLayer)
            view.layer.addSublayer(horizontalAxesLayer)
        }
    }

    func addYAxisLabel(for lines: Graph, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

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

    func addXAxisLabel(for lines: Graph, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

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

    //MARK: - functions for tests
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

}




