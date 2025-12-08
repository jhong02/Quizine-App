import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Soft Wii / aero gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.60, green: 0.90, blue: 1.0),
                        Color(red: 0.35, green: 0.80, blue: 0.95),
                        Color(red: 0.25, green: 0.75, blue: 0.80)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Slight bokeh blobs
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.35))
                        .blur(radius: 28)
                        .frame(width: 180, height: 180)
                        .offset(x: -110, y: -260)

                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .blur(radius: 24)
                        .frame(width: 150, height: 150)
                        .offset(x: 130, y: -120)

                    Circle()
                        .fill(Color.white.opacity(0.22))
                        .blur(radius: 30)
                        .frame(width: 220, height: 220)
                        .offset(x: 90, y: 260)
                }

                // Wii-style central panel
                VStack(spacing: 18) {

                    WiiTitlePill(text: "quizine")

                    Text("tap in and let leche guess your cravings")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color.black.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)

                    VStack(spacing: 14) {
                        NavigationLink(destination: StartView()) {
                            Text("Start")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(WiiPrimaryButtonStyle())

                        NavigationLink(destination: AboutView()) {
                            Text("About")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(WiiSecondaryButtonStyle())
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 4)
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color(red: 0.96, green: 0.98, blue: 1.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 26, style: .continuous)
                                .stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 10)
                )
                .padding(.horizontal, 32)
            }
        }
    }
}

// MARK: - Wii Components

struct WiiTitlePill: View {
    let text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.93, green: 0.98, blue: 1.0),
                            Color(red: 0.80, green: 0.92, blue: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.9),
                                    Color.black.opacity(0.15)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)

            Text(text)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color.black.opacity(0.8))
        }
        .frame(height: 52)
        .padding(.horizontal, 8)
    }
}

// Big blue Wii-style button
struct WiiPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.68, green: 0.91, blue: 1.0),
                                    Color(red: 0.18, green: 0.55, blue: 1.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.85),
                                    Color.white.opacity(0.0)
                                ],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .padding(.horizontal, 2)
                        .padding(.top, 2)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.9), lineWidth: 1)
            )
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.25), radius: 9, x: 0, y: 6)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.92 : 1.0)
    }
}

// Grey "Cancel" style button
struct WiiSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .regular))
            .padding(.vertical, 9)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.97, green: 0.98, blue: 0.99),
                                Color(red: 0.87, green: 0.90, blue: 0.93)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
            )
            .foregroundColor(Color.black.opacity(0.75))
            .shadow(color: .black.opacity(0.20), radius: 6, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.93 : 1.0)
    }
}

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
