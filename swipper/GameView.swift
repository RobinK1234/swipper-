import SwiftUI
import Combine

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    private let gridSize = 10
    private let mineCount = 15
    @State private var board: [[Cell]] = Array(repeating: Array(repeating: Cell(), count: 10), count: 10)
    @State private var showMineAlert = false
    @State private var gameStarted = false
    @State private var timeElapsed = 0
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color(hex: "00CF3A"), Color(hex: "0085FF")]),
                           startPoint: .bottom,
                           endPoint: .top)
                .edgesIgnoringSafeArea(.all)
            
            // Main content including the grid and buttons
            VStack {
                // Timer view
                if gameStarted {
                    Text("Time: \(timeElapsed)")
                        .fontWeight(.semibold)
                        .onReceive(timer) { _ in
                        self.timeElapsed += 1
                    }
                        .foregroundColor(.white)
                }
                
                // Minesweeper grid
                VStack {
                    ForEach(0..<gridSize, id: \.self) { row in
                        HStack {
                            ForEach(0..<gridSize, id: \.self) { column in
                                CellView(cell: self.$board[row][column])
                                    .onTapGesture {
                                        if !self.gameStarted {
                                            self.startGame()
                                        }
                                        if self.board[row][column].isMine {
                                            self.showMineAlert = true
                                            self.timer.connect().cancel()
                                        } else {
                                            self.revealCell(at: (row, column))
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding()
                
                // Buttons
                HStack {
                    // Reset Game button
                    Button("Reset Game") {
                        self.resetGame()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .fontWeight(.semibold)
                    
                    Spacer() // This will ensure buttons are spaced evenly on the sides
                    
                    // Back button
                    Button("Back") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .fontWeight(.semibold)
                }
                .padding() // Padding around the HStack
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: setupGame)
        .alert(isPresented: $showMineAlert) {
            Alert(
                title: Text("Boom!"),
                message: Text("You tapped on a mine. Try again."),
                dismissButton: .default(Text("Reset Game"), action: {
                    self.resetGame()
                })
            )
        }
    }

    private func startGame() {
        self.gameStarted = true
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
        self.timer.connect().store(in: &self.cancellables)
    }

    private func resetGame() {
        // Cancel the timer
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        // Reset the board state and mines
        board = Array(repeating: Array(repeating: Cell(), count: gridSize), count: gridSize)
        setupGame()
        // Reset timer and game started flag
        gameStarted = false
        timeElapsed = 0
    }

    private func revealCell(at position: (row: Int, col: Int)) {
        if !board[position.row][position.col].isRevealed {
            board[position.row][position.col].isRevealed = true
            
            // If cell has no adjacent mines, reveal its neighbors recursively (basic flood fill)
            if board[position.row][position.col].adjacentMines == 0 {
                for adjacentRow in max(position.row-1, 0)...min(position.row+1, gridSize-1) {
                    for adjacentCol in max(position.col-1, 0)...min(position.col+1, gridSize-1) {
                        if !board[adjacentRow][adjacentCol].isRevealed && !board[adjacentRow][adjacentCol].isMine {
                            revealCell(at: (adjacentRow, adjacentCol))
                        }
                    }
                }
            }
        }
    }

    private func setupGame() {
        // Randomly place mines
        var minesPlaced = 0
        while minesPlaced < mineCount {
            let randomRow = Int.random(in: 0..<gridSize)
            let randomCol = Int.random(in: 0..<gridSize)
            if !board[randomRow][randomCol].isMine {
                board[randomRow][randomCol].isMine = true
                minesPlaced += 1
            }
        }

        // Calculate adjacent mines for each cell
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                var adjacentMines = 0
                for adjacentRow in max(row-1, 0)...min(row+1, gridSize-1) {
                    for adjacentCol in max(col-1, 0)...min(col+1, gridSize-1) {
                        if board[adjacentRow][adjacentCol].isMine {
                            adjacentMines += 1
                        }
                    }
                }
                board[row][col].adjacentMines = adjacentMines
            }
        }
    }
}

struct CellView: View {
    @Binding var cell: Cell

    var body: some View {
        ZStack {
            Rectangle()
                .fill(cell.isRevealed ? (cell.isMine ? Color.red : Color.white) : Color.gray)
                .border(Color.black)
            if cell.isRevealed && !cell.isMine {
                Text(cell.adjacentMines > 0 ? "\(cell.adjacentMines)" : "")
                    .foregroundColor(cell.adjacentMinesColor)
            }
            if cell.isRevealed && cell.isMine {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.black)
            }
        }
        .frame(width: 30, height: 30)
    }
}

struct Cell {
    var isMine = false
    var isRevealed = false
    var adjacentMines = 0
}

extension Cell {
    var adjacentMinesColor: Color {
        switch adjacentMines {
        case 1: return .blue
        case 2: return .green
        case 3: return .red
        case 4...: return .purple
        default: return .black
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
