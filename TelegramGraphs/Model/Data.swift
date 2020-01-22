//
//  Data.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/23/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import Foundation

var graphJSON = GraphJSONModel()
var graphArray = GraphArray()

func getDataFromJSON(withName file: String) -> GraphJSONModel {
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

func convertIntoInternalFormat(from data: GraphJSONModel) -> [GraphArray] {

    //                linesArray = chartData.map{
    //
    //                    let date = NSDate(timeIntervalSince1970: TimeInterval(milliseconds))
    //                    let formatter = DateFormatter()
    //                    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    //                    formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
    //                    print(formatter.string(from: date as Date))
    //
    //                    output:
    //
    //                    LinesArray(id: <#T##Int#>, nameX: <#T##String#>, timeX: <#T##[String]#>, lines: <#T##[Line]#>)
    //                }

    return [GraphArray]()
}
