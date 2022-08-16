//
//  PuzzlePosition.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 08.08.2022.
//

import Foundation
import SwiftUI

class PuzzlePosition {
    static let instance = PuzzlePosition()
    
    
    let MARGIN = 0
    let SIZE = Int(UIScreen.main.bounds.size.width) / 3 - 15
    let COL = 3
    
    
    func getContainerSize() -> CGFloat{
        return CGFloat(SIZE * COL + MARGIN)
    }
    
    func getPuzzleSize() -> CGFloat{
        return CGFloat(SIZE - MARGIN )
    }
    
    
    func getPosition(id: Int) -> CGPoint{
        let floorTe = floor(Double(id / COL))
        let x = id % COL == 0  ? 0 : id % COL == 1 ? SIZE : SIZE * 2
        let y = Int(floorTe) * SIZE
        
        
        return CGPoint(x: x, y: y)
        
        
    }
    
    func getOrder(positon: CGPoint) -> Int{
        let x = Int(round(Double(Int(positon.x) / SIZE))) * SIZE
        let y = Int(round(Double(Int(positon.y) / SIZE))) * SIZE
        
        let row = Swift.max(y, 0) / SIZE
        
        let col = Swift.max(x, 0) / SIZE
        
        return Swift.min(row * COL + col, 8)
    }
    
}

