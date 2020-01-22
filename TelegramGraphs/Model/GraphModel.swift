//
//  GraphModel.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 1/21/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.


//import Foundation
//
//class GraphModel: Decodable {
//
//    let columnsArrays: [[String]]
//    let typesTulpins: [String:String]
//    let namesTulpins: [String:String]
//    let colorsTulpins: [String:String]
//
//    enum CraphModelRootKeys: String, CodingKey {
//        case columnsArrays = "columns"
//        case typesTulpins = "types"
//        case namesTulpins = "names"
//        case colorsTulpins = "colors"
//    }
//
//    required init(from decoder: Decoder) throws {
//        let rootContainer = try decoder.container(keyedBy: CraphModelRootKeys.self)
//
//        self.columnsArrays = try rootContainer.decode([[String]].self, forKey: .columnsArrays)
//        self.typesTulpins = try rootContainer.decode([String:String].self, forKey: .typesTulpins)
//        self.namesTulpins = try rootContainer.decode([String:String].self, forKey: .namesTulpins)
//        self.colorsTulpins = try rootContainer.decode([String:String].self, forKey: .colorsTulpins)
//    }
//}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let graphModel = try? newJSONDecoder().decode(GraphModel.self, from: jsonData)

import Foundation

typealias GraphModel = [GraphModelElement]

// MARK: - GraphModelElement
struct GraphModelElement: Codable {
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
