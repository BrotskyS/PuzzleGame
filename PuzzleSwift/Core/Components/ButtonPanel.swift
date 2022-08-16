//
//  ButtonPanel.swift
//  PuzzleSwift
//
//  Created by Sergiy Brotsky on 16.08.2022.
//

import SwiftUI

struct ButtonPanel: View {
    @EnvironmentObject var vm: LevelViewModel
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "arrow.counterclockwise")
                .frame(width: 20, height: 20)
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 100)
                        .fill(vm.averageColor)
                )
                .clipped()
                .shadow(color: .black.opacity(0.3), radius: 5, x: 5, y: 5)
            
            Spacer()
            Image(systemName: "eye")
                .frame(width: 20, height: 20)
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 100)
                        .fill(vm.averageColor)
                )
                .clipped()
                .shadow(color: .black.opacity(0.3), radius: 5, x: 5, y: 5)
            Spacer()
        }
        .padding()
        .background(
            vm.averageColor
        )
        .cornerRadius(20)
        .clipped()
        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
    }
}

struct ButtonPanel_Previews: PreviewProvider {
    static var previews: some View {
        ButtonPanel()
            .environmentObject(LevelViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
