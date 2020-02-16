//
//  Collections+Extension.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 2/15/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import Foundation
extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
