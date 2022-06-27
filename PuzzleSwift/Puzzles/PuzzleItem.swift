
import SwiftUI

struct PuzzleItem: View {
    @EnvironmentObject var viewModel: PuzzleViewModel
    @State var startPosition = CGPoint.zero
    @State var position = CGPoint.zero
    let puzzle: Puzzle

    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius:15)
                .frame(width: viewModel.getPuzzleSize(), height: viewModel.getPuzzleSize())
            
                .foregroundColor(puzzle.color)
                .scaleEffect(viewModel.currentOverlayId == viewModel.positions[puzzle.id] ? 1.2: 1)
            Text("\(puzzle.id)")
            
        }
//        .padding(.leading, 100)
//        .padding(.top, 100)
        
        .zIndex(viewModel.currentDragingId == viewModel.positions[puzzle.id] ? 1 : 0)
        .offset(x: position.x, y: position.y)
        .gesture(
            DragGesture().onChanged { value in
                let x = value.translation.width + startPosition.x
                let y = value.translation.height + startPosition.y
                position = CGPoint(x: x , y: y )
                viewModel.currentDragingId = viewModel.positions[puzzle.id]
                viewModel.updateOverlayWheneDrag(position: CGPoint(x: x + viewModel.getPuzzleSize() / 2, y: y + viewModel.getPuzzleSize() / 2), puzzle: puzzle)
            }
                .onEnded { value in
                    if !viewModel.onEndDrag(puzzle: puzzle){
                                            withAnimation(.spring()) {
                                                position = startPosition
                                            }
                    }
                    
                    viewModel.currentDragingId = nil
                    viewModel.currentOverlayId = nil

                }
        )
        .onChange(of: viewModel.positions[puzzle.id], perform: { newValue in
            if let newValue = newValue{
                withAnimation {
                    startPosition = viewModel.getPosition(id: newValue)
                    position = viewModel.getPosition(id: newValue)
                }
            }
            
        })
        .onAppear{
            withAnimation {
                startPosition = viewModel.getPosition(id: puzzle.id)
                position = viewModel.getPosition(id: puzzle.id)
            }

        }
   
        
    }
}

struct PuzzleItem_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleItem(puzzle: Puzzle(id: 1, color: .blue))
            .environmentObject(PuzzleViewModel())
    }
}
