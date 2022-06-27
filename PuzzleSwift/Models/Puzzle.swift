//
//  Puzzle.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 26.06.2022.
//

import Foundation
import SwiftUI


struct Puzzle: Equatable{
    let id: Int
    let color: Color
}


extension Puzzle {
    static let all = [
        Puzzle(id: 0, color: .red),
        Puzzle(id: 1, color: .blue),
        Puzzle(id: 2, color: .green),
        Puzzle(id: 3, color: .red),
        Puzzle(id: 4, color: .orange),
        Puzzle(id: 5, color: .purple),
        Puzzle(id: 6, color: .red),
        Puzzle(id: 7, color: .orange),
        Puzzle(id: 8, color: .purple)
    ]
}
