//
//  PuzzleList.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 26.06.2022.
//

import SwiftUI

struct PuzzleList: View {
    @StateObject private var viewModel = PuzzleViewModel()
    let gridItems = [
          GridItem(.flexible()),
          GridItem(.flexible()),
          GridItem(.flexible()),
      ]
    
    var body: some View {
        ZStack{
                ForEach(viewModel.puzzleList, id: \.id) { puzzle in
                    
                        PuzzleItem(
                            puzzle: puzzle
                        )
                        .environmentObject(viewModel)
                    
                 }
        }
        .padding()
        .frame(width: viewModel.getContainerSize(), height: viewModel.getContainerSize(), alignment: .topLeading)
        
        .background(.red.opacity(0.5))
        .cornerRadius(30)
    }
}

struct PuzzleList_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleList()
    }
}
