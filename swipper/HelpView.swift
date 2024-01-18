import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color(hex: "00CF3A"), Color(hex: "0085FF")]),
                           startPoint: .bottom,
                           endPoint: .top)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                // Minesweeper instructions
                Text("Instructions:\n\nThe objective of the game is to clear a rectangular board containing hidden \"mines\" without detonating any of them. Tap on tiles to reveal what is underneath. A number indicates how many mines are adjacent to that square, and using this information, you can deduce which tiles are safe to press. Clear all non-mine tiles to win the game!")
                    .font(.system(size: 20, weight: .bold))
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                Spacer()
                
                // Back button
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // Makes button full width
                        .background(Color.blue)
                        .cornerRadius(20)                 }
                .padding(.horizontal, 30)
            }
            .padding() // Padding around the entire VStack
        }
        .navigationBarHidden(true) // Hides the navigation bar
    }
}


struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
