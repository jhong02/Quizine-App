import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()   // fills whole iPhone screen

            Text("Food Guesser Base")
                .font(.title)
        }
    }
}

#Preview {
    ContentView()
}
