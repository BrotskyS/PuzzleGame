
import SwiftUI


struct PuzzleItemView: View {
    @AppStorage("selectedlevel") var selectedlevel = 0
    @EnvironmentObject var vm: LevelViewModel
    @State var startPosition = CGPoint.zero
    @State var position = CGPoint.zero
    @State var image: Image?
    let puzzle: Puzzle
    @AppStorage("showPreview") var showPreview = true
    let impactSoft = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        ZStack{
            if let image = vm.cropImage(puzzleId: puzzle.id){
                Image(uiImage:  image)
                    
            }
    
      
        }
        .zIndex(vm.currentDragingId == vm.positionsUI[puzzle.id] ? 1 : 0)
        .offset(x: position.x, y: position.y)
        .gesture(
            DragGesture()
                .onChanged { value in
                    let x = value.translation.width + startPosition.x
                    let y = value.translation.height + startPosition.y
                    position = CGPoint(x: x , y: y )
                    
                    vm.updateOverlayWheneDrag(position: CGPoint(x: x + vm.puzzlePosition.getPuzzleSize() / 2, y: y + vm.puzzlePosition.getPuzzleSize() / 2), puzzle: puzzle)
                }
                .onEnded { value in
                    if !vm.onEndDrag(puzzle: puzzle, position: CGPoint(x: position.x + vm.puzzlePosition.getPuzzleSize() / 2, y: position.y + vm.puzzlePosition.getPuzzleSize() / 2)){
                        withAnimation(.spring()) {
                            position = startPosition
                        }
                    }
                    else{
                        impactSoft.impactOccurred()
                    }
                    
                    if vm.positionsReal == Puzzle.initList {
                    
                    }
//
//                    vm.currentDragingId = nil
//                    vm.currentOverlayId = nil
                    
                }
        )
        .onLongPressGesture(minimumDuration: 100.0, maximumDistance: .infinity, pressing: { pressing in
            if pressing {
//                showPreview = true
                vm.currentDragingId = vm.puzzlePosition.getOrder(positon: CGPoint(x: position.x + vm.puzzlePosition.getPuzzleSize() / 2, y: position.y + vm.puzzlePosition.getPuzzleSize() / 2))
            }
        }, perform: { })
        
        .onChange(of: vm.positionsUI, perform: { newValue in
            
            if let newValue = newValue[puzzle.id]{
                withAnimation {
                    startPosition = vm.puzzlePosition.getPosition(id: newValue)
                    position = vm.puzzlePosition.getPosition(id: newValue)
                    
                }
                
            }
        })
        .onChange(of: selectedlevel, perform: { newValue in
            initPuzzle()
        })
        .onAppear{
            initPuzzle()
        }
    }
    
    func initPuzzle(){
        
        startPosition = vm.puzzlePosition.getPosition(id: puzzle.id)
        position = vm.puzzlePosition.getPosition(id: puzzle.id)
    }
}

struct PuzzleItemView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleItemView(puzzle: Puzzle(id: 0, color: Color.red))
            .environmentObject(LevelViewModel())
    }
}
