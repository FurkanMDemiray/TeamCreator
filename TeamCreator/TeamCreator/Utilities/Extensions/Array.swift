//
//  Array.swift
//  TeamCreator
//
//  Created by Melik Demiray on 8.08.2024.
//

import Foundation

extension Array {
    func shuffled() -> Array {
        var elements = self
        for index in elements.indices.dropLast() {
            let randomIndex = index.advanced(by: Int.random(in: 0..<(elements.distance(from: index, to: elements.endIndex))))
            elements.swapAt(index, randomIndex)
        }
        return elements
    }
}
