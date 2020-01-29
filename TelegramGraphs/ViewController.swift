//
//  ViewController.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/21/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var graphImageView: GraphView!
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!

    private struct Constant {
        static let margin: CGFloat = 20
        static let topBorder: CGFloat = 10.0
        static let bottomBorder: CGFloat = 40.0
        static let countHorizontalLine = 6
        static let countXValues = 6
    }

    let axesLayer = CALayer()
    var graphLayers = [CALayer()]

    let graphArray = {
        return graphData[0]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setDefaultState()

        var buttonsName = [(title: String?, color: UIColor?, id: Int?)?]()
        buttonsName = graphArray().lines.map { ($0.name,$0.color,$0.id) }

        // КОСТЫЛЬ!!!

        configureButton(button1, title: buttonsName[0]?.title, color: buttonsName[0]?.color, idLine: buttonsName[0]?.id)
        configureButton(button2, title: buttonsName[1]?.title, color: buttonsName[1]?.color, idLine: buttonsName[0]?.id)

        makeGraphs(for: graphArray())
    }

    func setDefaultState() {
        button1.isHidden = true
        button2.isHidden = true
        button3.isHidden = true
        button4.isHidden = true
    }

    func configureButton(_ button: UIButton, title: String?, color: UIColor?, idLine: Int?) {

        //  доделать радиобаттон с динамическим цветом !!!
        
        button.setTitle(title, for: .normal)
        button.tintColor = UIColor.black
        button.isHidden = false
        button.backgroundColor = color
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.opacity = 1
        button.tag = idLine!
        button.addTarget(self, action: #selector(changeIsHiddenParameter(sender:)), for: .touchUpInside)
    }

    @objc func changeIsHiddenParameter(sender: UIButton){

        // КОСТЫЛЬ!!!

        graphData[0].lines[0].isHidden = true

        makeGraphs(for: graphArray())
    }

    //MARK: - drawing

    func makeGraphs(for lines: GraphArray) {

        let graphWidth = graphImageView.bounds.width - 2 * Constant.margin
        let graphHeight = graphImageView.bounds.height - Constant.topBorder - Constant.bottomBorder

        let activeGraphs = lines.lines.filter {
            $0.isHidden == false
        }

        // calculate x points
        let xPointsCount = lines.timeX.count

        let columnXPoint = {
            (column: Float) -> CGFloat in
            let spacing = graphWidth / CGFloat(xPointsCount - 1)
            return CGFloat(column) * spacing
        }

        // drawing of graphs
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: graphWidth, height: graphHeight))

        var maxYPoint = 0
        activeGraphs.forEach {
            if $0.points.max()! > maxYPoint {
                maxYPoint = $0.points.max()!
            }
        }

        //calculate and draw axes and labels

        let oldAxesLayerContent = axesLayer.contents

        let axesImage = renderer.image { (context) in
            drawAxesGrid(for: lines, in: context, graphWidth, graphHeight)
            addXAxisLabel(for: lines, graphWidth, graphHeight)
//            addYAxisLabel(for: lines, graphWidth, graphHeight)
        }

        axesLayer.frame = self.graphImageView.frame
        axesLayer.contents = axesImage.cgImage

        if let _ = oldAxesLayerContent {
            let transition = CATransition()
            transition.duration = 1.0
            transition.type = .fade
            axesLayer.add(transition, forKey: nil)
        } else {
            view.layer.addSublayer(axesLayer)
        }


        // calculate y points
        activeGraphs.forEach {
            let graph = $0
            let graphImage = renderer.image{ (context) in
                let yPoints = graph.points
                let columnYPoint = {
                    (yPoint: Int) -> CGFloat in
                    let y = CGFloat(yPoint) * (graphHeight / CGFloat(maxYPoint))
                    return graphHeight - y
                }

                context.cgContext.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(yPoints[0])))
                for (index, value) in yPoints.enumerated() {
                    let nextPoint = CGPoint(x: columnXPoint(Float(index)), y: columnYPoint(value))
                    context.cgContext.addLine(to: nextPoint)
                }

                context.cgContext.setStrokeColor(graph.color!.cgColor)
                context.cgContext.setLineWidth(2.0)
                context.cgContext.setAlpha(1)
                context.cgContext.drawPath(using: .stroke)
            }

            graphLayers.forEach {
                if ($0.name == String(graph.id)) {
                    let transition = CATransition()
                    transition.duration = 5.0
                    transition.type = .fade
                    $0.add(transition, forKey: nil)
                    return
                }
            }

            let graphLayer = CALayer()
            graphLayer.name = String(graph.id)
            graphLayer.frame = self.graphImageView.frame
            graphLayer.contents = graphImage.cgImage
            view.layer.addSublayer(graphLayer)
            graphLayers.append(graphLayer)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    private func drawAxesGrid(for lines: GraphArray, in context: UIGraphicsImageRendererContext, _ graphWidth: CGFloat, _ graphHeight: CGFloat) {
        let maxXCoordinate = graphWidth
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
        var yPosition = graphHeight
        for _ in 0..<spacingCount {
            yPositionArray.append(yPosition)
            yPosition -= spacing
        }

        yPositionArray.forEach {
            context.cgContext.move(to: CGPoint(x: 0, y: $0))
            context.cgContext.addLine(to: CGPoint(x: maxXCoordinate, y: $0))

            context.cgContext.setLineWidth(1.5)
            context.cgContext.setStrokeColor(UIColor.lightGray.cgColor)
            context.cgContext.setAlpha(0.2)
            context.cgContext.drawPath(using: .stroke)
        }
    }

    private func addYAxisLabel(for lines: GraphArray, _ graphWidth: CGFloat, _ graphHeight: CGFloat) {
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
        var yLabelPosition = graphHeight - labelShiftY
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
            graphImageView.addSubview(yLabel)
        }
    }

    private func addXAxisLabel(for lines: GraphArray, _ graphWidth: CGFloat, _ graphHeight: CGFloat) {

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
            let yLabelWidth = CGFloat(100)
            let yLabelHeight = CGFloat(20)
            xLabelPosition = $0.xCoord - yLabelHeight
            let yLabel = UILabel(frame: CGRect(x: $0.xCoord, y: yLabelPosition, width: yLabelWidth, height: yLabelHeight))
            yLabel.text = $0.value
            yLabel.textColor = .lightGray
            graphImageView.addSubview(yLabel)
        }
    }


}
