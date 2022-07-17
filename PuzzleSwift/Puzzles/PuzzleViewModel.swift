//
//  PuzzleViewModel.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 26.06.2022.
//

import SwiftUI
import Foundation
import AVKit
import Combine


class PuzzleViewModel: ObservableObject {
    
    
    @Published var currentOverlayId: Int?
    @Published var currentDragingId: Int?
    /// In console you see bad numbers, but it work in UI
    @Published public private(set) var positionsUI:  [Int: Int] = Dictionary(uniqueKeysWithValues: Puzzle.all.map{ ($0.id, $0.id) })
    /// This is for music
    @Published public private(set) var positionsReal:  [Int: Int] = Dictionary(uniqueKeysWithValues: Puzzle.all.map{ ($0.id, $0.id) })
    @Published var currentPlay: Int?
    var player: AVAudioPlayer?
    
    private var isPlayAll = false
    lazy var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] time in
        if let currentTime = self.player?.currentTime{
            if isPlayAll{
                let array = self.timeCodes.filter({currentTime >= $0.value})
                print("array \(array)")
                let index = Array(array.keys).sorted()[array.count - 1]
                
                
                //            if let index = index {
                if index != self.positionsReal[index] && currentPlay !=  index{
                    print("seek \(self.timeCodes[index]!)")
                    self.player?.currentTime = self.timeCodes[self.positionsReal[index]!]!
                }
                print("positions \(index) \(self.positionsReal)")
                self.currentPlay = index
            }
            
            
            //            }
//                        self.currentPlay =  self.timeCodes.first { (key, value) in
//                            return  currentTime <= value
//                        }?.key
        }
        
    }
    
    
    private var cancellable = Set<AnyCancellable>()
    
    
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
        guard let currentDragingId = currentDragingId else {return}
        let orderId = getOrder(positon: position)
        withAnimation {
            if currentDragingId != orderId{
                currentOverlayId = positionsReal[orderId]
            }else{
                currentOverlayId = nil
            }
        }
        
        
        
    }
    
    func onEndDrag(puzzle: Puzzle, position: CGPoint) -> Bool{
        
        
        guard let currentDragingId = currentDragingId else {return false}
        
        //        Real positions
        var newPositionReal = positionsReal
        let newOrder = getOrder(positon: position)
        newPositionReal[currentDragingId] = positionsReal[newOrder]
        newPositionReal[newOrder] = positionsReal[currentDragingId]
        positionsReal = newPositionReal
        
        
        //        UI Positions
        var newPositionUI = positionsUI
        let oldOlder = newPositionUI[puzzle.id]
        
        
        if let idToSwap = newPositionUI.keys.first(where: {newPositionUI[$0] == newOrder}), newOrder != oldOlder{
            newPositionUI[puzzle.id] = newOrder
            newPositionUI[idToSwap] = oldOlder
            
            positionsUI = newPositionUI
            
            return true
        }
        
        return false
    }
    
    
    //    MARK: sound
    
    init(){
        guard let url = Bundle.main.url(forResource: "sound", withExtension: ".mp3") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            
//            timer.fire()
        }catch let error{
            print("Error play sound \(error)")
        }
    }
    
    
    
    let timeCodes: [Int: Double] = [
        0: 0,
        1: 5,
        2: 10,
        3: 15,
        4: 100,
        5: 120,
        6: 150,
        7: 200,
        8: 210
    ]
    
    func playSound(id: Int){
        if let player = player{
            currentPlay = id
            isPlayAll = false
            guard let timeCode = timeCodes[id] else {return print("DEBUG: cant find time code")}
            if !player.isPlaying{
                player.play()
            }
            player.currentTime = timeCode
        }
        
    }
    
    func playAll(){
        player?.currentTime = 0
        player?.play()
        isPlayAll = true
        
    }
    
    func stop(){
        player?.pause()
        isPlayAll = false
    }
    
    
}


