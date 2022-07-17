
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
                .scaleEffect(viewModel.currentOverlayId == puzzle.id ? 1.2: 1)
            Text("\(puzzle.id)")
            
        }
        .shadow(color: .red, radius: viewModel.currentPlay == viewModel.positionsReal[puzzle.id] ?  20 : 0, x: 0, y: 0)
        .zIndex(viewModel.currentDragingId == viewModel.positionsUI[puzzle.id] ? 1 : 0)
        .offset(x: position.x, y: position.y)
        .gesture(
            DragGesture()
            
                .onChanged { value in
                    let x = value.translation.width + startPosition.x
                    let y = value.translation.height + startPosition.y
                    position = CGPoint(x: x , y: y )
                    
                    viewModel.updateOverlayWheneDrag(position: CGPoint(x: x + viewModel.getPuzzleSize() / 2, y: y + viewModel.getPuzzleSize() / 2), puzzle: puzzle)
                }
                .onEnded { value in
                    if !viewModel.onEndDrag(puzzle: puzzle, position: CGPoint(x: position.x + viewModel.getPuzzleSize() / 2, y: position.y + viewModel.getPuzzleSize() / 2)){
                        withAnimation(.spring()) {
                            position = startPosition
                        }
                    }
                    
                    viewModel.currentDragingId = nil
                    viewModel.currentOverlayId = nil
                    
                }
        )
        .onLongPressGesture(minimumDuration: 100.0, maximumDistance: .infinity, pressing: { pressing in
            
            if pressing {
                viewModel.playSound(id: puzzle.id)
                viewModel.currentDragingId = viewModel.getOrder(positon: CGPoint(x: position.x + viewModel.getPuzzleSize() / 2, y: position.y + viewModel.getPuzzleSize() / 2))
            }
        }, perform: { })
        
        .onChange(of: viewModel.positionsUI[puzzle.id], perform: { newValue in
            
            if let newValue = newValue{
//                print("newValue: \(newValue), puzzleId: \(puzzle.id)")
//            if let idToSwap = newValue.keys.first(where: {newValue[$0] == puzzle.id}){
                withAnimation {
                    startPosition = viewModel.getPosition(id: newValue)
                    position = viewModel.getPosition(id: newValue)
                }
//            }
              
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
