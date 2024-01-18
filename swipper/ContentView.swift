import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "00CF3A"), Color(hex: "0085FF")]), startPoint: .bottom, endPoint: .top)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 30) {
                    
                    Text("MINESWIIPER")
                        .font(.system(size: 40, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40.0)
                        .padding(.vertical, 20)
                        .background(Color.green)
                        .cornerRadius(25)
                        .padding(.bottom, 100)

                    // Play Game button
                    NavigationLink(destination: GameView()) {
                        Text("Play game")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color(hex: "00CF3A"))
                            .frame(width: 300, height: 80)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                    .padding(.bottom, 20)

                    // Help button
                    NavigationLink(destination: HelpView()) {
                        Text("Help")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color(hex: "0085FF"))
                            .frame(width: 300, height: 80)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000ff) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
