//
//  PuzzleViewModel.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 26.06.2022.
//

import SwiftUI
import Foundation

class PuzzleViewModel: ObservableObject {
    
   
    @Published var currentOverlayId: Int?
    @Published var currentDragingId: Int?
    @Published var positions:  [Int: Int] = Dictionary(uniqueKeysWithValues: Puzzle.all.map{ ($0.id, $0.id) })
    
    
    let puzzleList = Puzzle.all
    
    let MARGIN = 15
    let SIZE = Int(UIScreen.main.bounds.size.width) / 3 - 15
    let COL = 3
    
    
    func getContainerSize() -> CGFloat{
        return CGFloat(SIZE * COL + MARGIN)
    }

    func getPuzzleSize() -> CGFloat{
        return CGFloat(SIZE - MARGIN + 4)
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
    
    
    private var frames: [Int: CGRect] = [:]
    
    
    func update(frame: CGRect, for id: Int) {
        frames[id] = frame
    }
    
    func updateOverlayWheneDrag(position: CGPoint, puzzle: Puzzle){
        let orderId = getOrder(positon: position)
        let oldOlder = positions[puzzle.id]
        withAnimation {
            if oldOlder != orderId{
                
                currentOverlayId = orderId
            }else{
                currentOverlayId = nil
            }
        }
        
       
        
    }
    
    func onEndDrag(puzzle: Puzzle) -> Bool{
        guard let currentOverlayId = currentOverlayId else {return false}
//        print("HETE\(positions[currentDragingId])")\
        var newPosition = positions
        let oldOlder = newPosition[puzzle.id]
      
        if let idToSwap = newPosition.keys.first(where: {newPosition[$0] == currentOverlayId}),oldOlder != currentOverlayId{
            newPosition[puzzle.id] = currentOverlayId
            newPosition[idToSwap] = oldOlder
            
            positions = newPosition
            
            return true
        }
        
        return false
    }
    
}


