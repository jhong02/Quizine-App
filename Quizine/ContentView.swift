import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("quizine")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                NavigationLink(destination: StartView()) {
                    Text("Start")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                NavigationLink(destination: AboutView()) {
                    Text("About")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
        }
    }
}

struct StartView: View {
    var body: some View {
        Text("Start Screen")
            .font(.title)
    }
}

struct AboutView: View {
    var body: some View {
        Text("About Screen")
            .font(.title)
    }
}

#Preview {
    ContentView()
}
