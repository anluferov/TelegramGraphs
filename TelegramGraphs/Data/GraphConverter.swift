//
//  Data.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/23/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import Foundation

class GraphConverter {

    func convertIntoInternalFormatFromJson(withName file: String) -> [Graph] {
        let graphsInInternalFormat = getDataFromJSON(withName: "chart_data").map {
            convertIntoInternalFormat(from: $0)
        }

        return graphsInInternalFormat
    }

    // Fetching data from JSON
    private func getDataFromJSON(withName file: String) -> GraphJSONModel {
        var graphJSON = GraphJSONModel()
        if let path = Bundle.main.path(forResource: file, ofType: "json") {
            do {
                let chartDataFile = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                graphJSON = try JSONDecoder().decode(GraphJSONModel.self, from: chartDataFile)
              } catch {
                   print(error)
              }
        }
        return graphJSON
    }

    // Converting data into internal format
    private func convertIntoInternalFormat(from data: GraphJSONModelElement) -> Graph {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd")

        let graphArray = Graph()
        var nameLine = ""
        var values = [Int]()
        var lines = [Line]()

        for line in data.columns {
            for element in line {
                switch element {
                    case .integer(let value): values.append(value)
                    case .string(let name): nameLine = name
                }
            }

            switch nameLine {
                case "x":
                    graphArray.nameX = nameLine
                    graphArray.colorX = data.colors.x != nil ? data.colors.x!.hexStringToUIColor() : nil
                    graphArray.timeX = values.map{
                        dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval($0/1000)))
                    }
                case "y0":
                    lines.append(Line(layerIndex: lines.count,
                                       name: data.names.y0,
                                       type: data.types.y0,
                                       color: data.colors.y0.hexStringToUIColor(),
                                       isHidden: false,
                                       points: values,
                                       countY: values.count))
                case "y1":
                    lines.append(Line(layerIndex: lines.count,
                                       name: data.names.y1,
                                       type: data.types.y1,
                                       color: data.colors.y1.hexStringToUIColor(),
                                       isHidden: false,
                                       points: values,
                                       countY: values.count))
                case "y2":
                    lines.append(Line(layerIndex: lines.count,
                                       name: data.names.y2!,
                                       type: data.types.y2!,
                                       color: data.colors.y2 != nil ? data.colors.y2!.hexStringToUIColor() : nil,
                                       isHidden: false,
                                       points: values,
                                       countY: values.count))
                case "y3":
                    lines.append(Line(layerIndex: lines.count,
                                       name: data.names.y3!,
                                       type: data.types.y3!,
                                       color: data.colors.y3 != nil ? data.colors.y3!.hexStringToUIColor() : nil,
                                       isHidden: false,
                                       points: values,
                                       countY: values.count))
                default: break
            }

            nameLine = ""
            values = [Int]()
        }

        graphArray.lines = lines

        return graphArray
    }

}


