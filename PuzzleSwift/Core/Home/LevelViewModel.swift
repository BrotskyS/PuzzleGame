//
//  LevelViewModel.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 29.07.2022.
//

import SwiftUI
import Foundation
import Combine


class LevelViewModel: ObservableObject {
    @AppStorage("unlockLevel") var unlockLevel = 0
    
    @Published var currentOverlayId: Int?
    @Published var currentDragingId: Int?
    @Published public private(set) var positionsUI:  [Int: Int] = Puzzle.initList
    @Published public private(set) var positionsReal:  [Int: Int] = Puzzle.initList
    @Published var image: UIImage?
    @Published var averageColor: Color = .clear
    
    
    let puzzlePosition = PuzzlePosition.instance
    
    init(){
        initLevel()
    }
    
    
    func initLevel(){
        
        
        guard let url = URL(string: "https://picsum.photos/500") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        self?.image = UIImage(data: data)
                        self?.averageColor = Color(UIImage(data: data)?.averageColor ?? .clear)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
        
    }
    
    
    func cropImage(puzzleId: Int) -> UIImage? {
        let size = puzzlePosition.getPuzzleSize()
        let position = puzzlePosition.getPosition(id: puzzleId)
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x: position.x,
                              y: position.y,
                              width:size ,
                              height:size)
        
        // Perform cropping in Core Graphics
        if let image = image {
            guard let cutImageRef: CGImage = image.cgImage?.cropping(to:cropZone)
            else {
                return nil
            }
            
            let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
            return croppedImage
        }else {
            return nil
        }
      
        
       
    }
    
    
    func updateOverlayWheneDrag(position: CGPoint, puzzle: Puzzle){
        guard let currentDragingId = currentDragingId else {return}
        let orderId = puzzlePosition.getOrder(positon: position)
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
        let newOrder = puzzlePosition.getOrder(positon: position)
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
    
    
    
    
    
    
    
    func resetLevel(){
        positionsUI = Puzzle.initList
        positionsReal = Puzzle.initList
    }
    
}
