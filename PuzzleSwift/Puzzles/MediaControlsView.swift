//
//  MediaControlsView.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 10.07.2022.
//

import SwiftUI

struct MediaControlsView: View {
    @EnvironmentObject var viewModel: PuzzleViewModel
    var body: some View {
        HStack{
            Button{
                viewModel.playAll()
            }label: {
                Image(systemName: "play.fill")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .fill(.yellow)
                    )
            }
            
            Button{
                viewModel.stop()
            }label: {
                Image(systemName: "stop.fill")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .fill(.yellow)
                    )
                
            }
        }
    }
}

struct MediaControlsView_Previews: PreviewProvider {
    static var previews: some View {
        MediaControlsView()
            .environmentObject(PuzzleViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
