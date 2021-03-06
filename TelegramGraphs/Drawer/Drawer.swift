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

    //array of CAShapeLayers. Each CAShapeLayer will contain a graph lines or axis lines
    var linesLayers = [CAShapeLayer]()
    var labelsXLayers = [CATextLayer]()
    var labelsYLayers = [CATextLayer]()
    let horizontalAxisLayer = CAShapeLayer()

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
            linesLayers.insert(graphLayer, at: $0.layerIndex)
            //add layer with line on view
            view.layer.addSublayer(graphLayer)
        }
    }

    func redrawLineForGraph(_ line: Line, for graph: Graph, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

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

            if let subLayer = linesLayers[safe: $0.layerIndex], let subLayerPath = subLayer.path {
                animator.animateChangingPath(from: subLayerPath, to: graphPath.cgPath, on: subLayer, duration: 0.25)
                subLayer.path = graphPath.cgPath

                //if this line was hidden, change opacity
                if subLayer.opacity == 0.0 {
                    subLayer.opacity = 1.0
                    animator.animateAppear(on: subLayer, duration: 0.5)
                }
            }
        }

        //hide all firstly hidden lines
        if let line = hiddenLines.first(where: {$0 === line}) {
            if let subLayer = linesLayers[safe: line.layerIndex] {
                subLayer.opacity = 0.0
                animator.animateDisappear(on: subLayer, duration: 0.5)
            }
        }

//        if let subLayer = linesLayers[safe: line.layerIndex] {
//            subLayer.opacity = 0.0
//            animator.animateDisappear(on: subLayer, duration: 0.5)
//        }
    }

    //MARK: - drawing of coordinate axes. return array with Y position of axis

    private func calculateAxisPositions(_ graphHeight: CGFloat) -> [CGFloat] {

        //calculate coordinate of top and lower lines
        let indentTopLineInPercent = 0.05
        let indentTopLine = graphHeight * CGFloat(indentTopLineInPercent)
        let topYAxisPosition = Constant.bottomBorder + indentTopLine
        let lowerYAxisPosition = Constant.bottomBorder + graphHeight

        //calculate spacing
        let spacing = (lowerYAxisPosition - topYAxisPosition) / CGFloat(Constant.countHorizontalLine-1)

        //create array of Y position for dX axis
        var yPositionArray = [CGFloat]()
        var yAxisPosition = lowerYAxisPosition
        for _ in 0..<Constant.countHorizontalLine {
            yPositionArray.append(yAxisPosition)
            yAxisPosition -= spacing
        }

        return yPositionArray
    }

    func drawHorizontalAxis(for graph: Graph, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

        //get array of Y position for axis
        let yPositionArray = calculateAxisPositions(graphHeight)

        //draw all horizontal lines and append their to final UIBezierPath
        let xPositionStartLine = Constant.margin
        let xPositionEndLine = Constant.margin + graphWidth
        let horizontalLines = UIBezierPath()
        yPositionArray.forEach {
            let horizontalLine = UIBezierPath()
            horizontalLine.move(to: CGPoint(x: xPositionStartLine, y: $0))
            horizontalLine.addLine(to: CGPoint(x: xPositionEndLine, y: $0))
            horizontalLines.append(horizontalLine)
        }

        //set layer for horizontal lines grid
        horizontalAxisLayer.strokeColor = UIColor.lightGray.cgColor
        horizontalAxisLayer.lineWidth = 0.5
        horizontalAxisLayer.fillColor = nil
        horizontalAxisLayer.opacity = 0.6
        if let _ = horizontalAxisLayer.path {
//            animator.animateChangingPath(from: oldPath, to: horizontalLines.cgPath, on: horizontalAxisLayer, duration: 0.5)
            horizontalAxisLayer.path = horizontalLines.cgPath
        } else {
            horizontalAxisLayer.path = horizontalLines.cgPath
            //add layer with grid on view
            view.layer.addSublayer(horizontalAxisLayer)
        }
    }

    func addYAxisLabel(for graph: Graph, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

        //get array of Y position for axis
        let yPositionArray = calculateAxisPositions(graphHeight)

        //size and indents for labels on dY
        let labelWidth = CGFloat(100)
        let labelHeight = CGFloat(15)
        let labelShiftY = CGFloat(5.0)
        let labelShiftX = CGFloat(0.0)

        //filter hidden and not hidden graphs for drawing
        let notHiddenLines = getLines(from: graph, type: .notHidden)

        //if all lines are disables - nothing to do
        guard !notHiddenLines.isEmpty else {
            return
        }

        //calculate label value on top axis and spacing for other values
        let maxYPoint = getMaxYPoint(for: notHiddenLines)
        let topAxisYCoord = yPositionArray.min()!
        let topAxisLabel = (graphHeight + Constant.topBorder - topAxisYCoord) / (graphHeight / CGFloat(maxYPoint))

        let spacingCount = Constant.countHorizontalLine - 1
        let spacingForValues = Int(topAxisLabel) / spacingCount

        //calculate coordinate of labels for dY and their values
        let labelXPosition = Constant.margin + labelShiftX
        var labelInfoArray = [(xCoord: CGFloat, yCoord: CGFloat, value: Int)]()
        var labelText = 0

        //calculate array with coordinate of Y label and their values
        yPositionArray.forEach {
            let labelYPosition = $0 - labelShiftY
            labelInfoArray.append((labelXPosition,labelYPosition,labelText))
            labelText += spacingForValues
        }

        // implementation with UILabel //

//        labelInfoArray.forEach {
//            let yCoord = $0.yCoord - labelHeight
//            let yLabel = UILabel(frame: CGRect(x: $0.xCoord, y: yCoord, width: labelWidth, height: labelHeight))
//            yLabel.text = String($0.value)
//            yLabel.textColor = .lightGray
//            view.addSubview(yLabel)
//        }

        // implementation with CATextLayer //

        if labelsYLayers.isEmpty {
            //create array labelsYLayers with all labels on dY and add labels on view
            labelInfoArray.forEach {
                let labelLayer = CATextLayer()
                labelLayer.string = String($0.value)
                labelLayer.fontSize = 15
                labelLayer.foregroundColor = UIColor.lightGray.cgColor
                labelLayer.contentsScale = UIScreen.main.scale

                let yCoord = $0.yCoord - labelHeight
                labelLayer.frame = CGRect(x: $0.xCoord, y: yCoord, width: labelWidth, height: labelHeight)

                labelsYLayers.append(labelLayer)
                view.layer.addSublayer(labelLayer)
            }
        } else {
            zip(labelInfoArray,labelsYLayers).forEach {
                let yCoord = $0.yCoord - labelHeight
                CATransaction.begin()
                $1.string = String($0.value)
                $1.frame = CGRect(x: $0.xCoord, y: yCoord, width: labelWidth, height: labelHeight)
                CATransaction.commit()
            }
        }
    }

    func addXAxisLabel(for graph: Graph, _ graphWidth: CGFloat, _ graphHeight: CGFloat, on view: UIView) {

        //size and indents for labels on dX
        let labelShiftY = CGFloat(5.0) //interval between bottom of graph and labels for dX axis
        let labelShiftX = CGFloat(5.0) //interval between border of graph and first label for dX axis
        let labelWidth = CGFloat(100)
        let labelHeight = CGFloat(20)

        //calculate spacing between labels on dX and index of timeX array
        let countXValues = graph.timeX.count
        let spacing = graphWidth / CGFloat(Constant.countXValues)
        let spacingForIndex = countXValues / Constant.countXValues

        //calculate coordinate of labels for dX and their values
        let labelYPosition = Constant.topBorder + graphHeight + labelShiftY
        var labelXPosition = Constant.margin + labelShiftX
        var labelInfoArray = [(xCoord: CGFloat, yCoord: CGFloat, value: String)]()
        var index = 0
        for _ in 0..<Constant.countXValues {
            let labelText = graph.timeX[index]
            labelInfoArray.append((labelXPosition,labelYPosition,labelText))
            labelXPosition += spacing
            index += spacingForIndex
        }

        // implementation with UILabel //

//        labelInfoArray.forEach {
//            let xLabel = UILabel(frame: CGRect(x: $0.xCoord, y: $0.yCoord, width: labelWidth, height: labelHeight))
//            xLabel.text = $0.value
//            xLabel.textColor = .lightGray
//            view.addSubview(xLabel)
//        }

        // implementation with CATextLayer //

        labelInfoArray.forEach {
            let labelLayer = CATextLayer()
            labelLayer.string = $0.value
            labelLayer.fontSize = 15
            labelLayer.foregroundColor = UIColor.lightGray.cgColor
            labelLayer.contentsScale = UIScreen.main.scale

            labelLayer.frame = CGRect(x: $0.xCoord, y: $0.yCoord, width: labelWidth, height: labelHeight)

            labelsXLayers.append(labelLayer)
            view.layer.addSublayer(labelLayer)
        }
    }
}




