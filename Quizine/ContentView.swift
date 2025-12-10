import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            WiiHomeScreen()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - Main Wii Home Screen

struct WiiHomeScreen: View {
    private let accentBlue = Color(red: 94/255, green: 184/255, blue: 212/255)

    var body: some View {
        ZStack {
            ScanlineBackground()

            VStack(spacing: 0) {
                // TOP: title + chevrons
                ZStack {
                    HStack {
                        Button(action: {
                            // left page action (optional)
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 34, weight: .heavy))
                                .foregroundColor(accentBlue)
                        }

                        Spacer()

                        Button(action: {
                            // right page action (optional)
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 34, weight: .heavy))
                                .foregroundColor(accentBlue)
                        }
                    }

                    WiiTitleText("Quizine", outlineColor: accentBlue)
                }
                .padding(.horizontal, 24)
                .frame(maxHeight: .infinity)

                // BOTTOM: buttons + settings
                ZStack(alignment: .bottomLeading) {
                    VStack(spacing: 16) {
                        NavigationLink(destination: StartView()) {
                            Text("Start")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(WiiMenuButtonStyle(accentBlue: accentBlue))
                        .frame(width: 260)

                        NavigationLink(destination: AboutView()) {
                            Text("About")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(WiiMenuButtonStyle(accentBlue: accentBlue))
                        .frame(width: 260)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Button {
                        // settings action (later)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color(red: 0.42, green: 0.42, blue: 0.42))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 24)
                    .padding(.bottom, 18)
                }
                .padding(.bottom, 24)
            }
            .frame(maxWidth: 430)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Title with Wii-style outline

struct WiiTitleText: View {
    let text: String
    let outlineColor: Color

    init(_ text: String, outlineColor: Color) {
        self.text = text
        self.outlineColor = outlineColor
    }

    var body: some View {
        Text(text)
            .font(.system(size: 56, weight: .bold, design: .rounded))
            .tracking(2)
            .foregroundColor(.white)
            // fake outline
            .shadow(color: outlineColor, radius: 0, x: 0, y: 0)
            .shadow(color: outlineColor, radius: 0, x: 3, y: 0)
            .shadow(color: outlineColor, radius: 0, x: -3, y: 0)
            .shadow(color: outlineColor, radius: 0, x: 0, y: 3)
            .shadow(color: outlineColor, radius: 0, x: 0, y: -3)
            // drop shadow
            .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Button style

struct WiiMenuButtonStyle: ButtonStyle {
    let accentBlue: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color(red: 0.29, green: 0.29, blue: 0.29))
            .padding(.vertical, 14)
            .padding(.horizontal, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white,
                                                Color(red: 0.91, green: 0.91, blue: 0.91)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Capsule()
                    .stroke(accentBlue, lineWidth: 3)
            )
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Scanline background

struct ScanlineBackground: View {
    var body: some View {
        ZStack {
            Color(red: 0.91, green: 0.91, blue: 0.91)
                .ignoresSafeArea()

            Canvas { context, size in
                let stripeHeight: CGFloat = 2
                var y: CGFloat = 0
                let stripeColor = Color(red: 0.87, green: 0.87, blue: 0.87)

                while y < size.height {
                    let rect = CGRect(x: 0, y: y, width: size.width, height: 1)
                    context.fill(Path(rect), with: .color(stripeColor))
                    y += stripeHeight
                }
            }
            .ignoresSafeArea()
        }
    }
}

// keep your existing AboutView (unchanged)
struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("About quizine")
                .font(.title2).bold()

            Text("Leche the cat helps you figure out what you're craving with a short quiz, then suggests food nearby.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}
