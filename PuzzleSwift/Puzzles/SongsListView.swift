//
//  SongsListView.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 27.06.2022.
//

import SwiftUI


struct SongsListView: View {
    var body: some View {
        HStack(spacing: 20){
            
            ForEach(1...3, id: \.self) { _ in
                VStack{
                    //MARK: STAR Image
                    ZStack {
                        Image(systemName: "star.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                        
                        LinearGradient(colors: [.white, .yellow], startPoint: .top, endPoint: .bottom)
                            .frame(width: 25, height: 25, alignment: .center)
                            .mask {
                                ZStack{
                                    Image(systemName: "star")
                                        .font(.title2)
                                    
                                }
                            }
                    }
                    .offset(y: 15)
                    .zIndex(2)
                    
                    ZStack{
                        
                        Text("Beggin")
                            .padding(.bottom, 10)
                        
                    }
                  
                    .frame(width: 100, height: 55, alignment: .bottom)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: .red, radius: 5, x: 0, y: 0)
                
                    
                }
            }
            
        }
    }
}

struct SongsListView_Previews: PreviewProvider {
    static var previews: some View {
        SongsListView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
