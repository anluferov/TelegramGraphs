//
//  GraphModel.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/21/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let graphModel = try? newJSONDecoder().decode(GraphModel.self, from: jsonData)

import Foundation
import UIKit

//MARK: - format of data from JSON
typealias GraphJSONModel = [GraphJSONModelElement]

// MARK: - GraphModelElement
struct GraphJSONModelElement: Codable {
    let columns: [[Column]]
    let types, names, colors: Names
}

// MARK: - Colors
struct Names: Codable {
    let y0, y1: String
    let y2, y3, x: String?
}

enum Column: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Column.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Column"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

//MARK: - interanl format of graph data
struct GraphArray {
    var nameX: String?
    var timeX = [String]()
    var colorX: UIColor?
    var lines = [Graph]()
}

struct Graph {
    var id: Int = 0
    var name: String?
    var type: String?
    var color: UIColor?
    var isHidden: Bool = false
    var points = [Int]()
    var countY = 0
}
