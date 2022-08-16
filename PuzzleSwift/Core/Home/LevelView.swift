//
//  LevelView.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 29.07.2022.
//

import SwiftUI

struct LevelView: View {
    @StateObject var vm = LevelViewModel()
    
    
    var body: some View {
        ZStack {
            vm.averageColor
                .ignoresSafeArea()
            
                VStack (spacing: 40){
                    HStack{
                        Text("Score: \(10)")
                            .font(.title.bold())
                        Spacer()
                    }
                    .padding(15)
                    
                    ZStack{
                        ForEach(Puzzle.all, id: \.id) { puzzle in
                            PuzzleItemView(
                                puzzle: puzzle
                            )
                            .environmentObject(vm)
                        }
                    }
                    .frame(width: vm.puzzlePosition.getContainerSize(), height: vm.puzzlePosition.getContainerSize(), alignment: .topLeading)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .background(

                    
                        bgImage
                     
                       
                       
                    )
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    ButtonPanel()
                        .environmentObject(vm)
                        .padding(15)
                }
                .onDisappear{
                    vm.resetLevel()
                }
                
            
        }
        
    }
    
    @ViewBuilder
    private var bgImage: some View  {
        if let image = vm.image {
            Image(uiImage: image )
                    .frame(width: vm.puzzlePosition.getContainerSize(), height: vm.puzzlePosition.getContainerSize(), alignment: .topLeading)
                    .blur(radius: 2)
                    .clipShape( RoundedRectangle(cornerRadius: 30))
        } else{
            Color.clear
        }
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        LevelView()
    }
}
