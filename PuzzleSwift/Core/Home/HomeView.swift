//
//  PuzzleList.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 26.06.2022.
//

import SwiftUI
import MusicKit

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        TabView {
            
                ZStack{
                    LevelView()
                    
                }
            
                
                
            
        }
        .onAppear(perform: {
            UIScrollView.appearance().bounces = false
        })
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
