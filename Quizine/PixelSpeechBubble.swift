import SwiftUI

struct PixelSpeechBubble: View {
    let text: String
    let isShaky: Bool

    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(Color.black.opacity(0.85))
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(
                ZStack {
                    // Outer Wii-blue pill
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.74, green: 0.91, blue: 1.0),
                                    Color(red: 0.51, green: 0.77, blue: 1.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    // Inner white pill
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color(red: 0.94, green: 0.97, blue: 1.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(2)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.9), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            .offset(x: isShaky ? shakeOffset : 0)
            .onAppear { startShakeIfNeeded() }
            .onChange(of: isShaky) { _ in
                startShakeIfNeeded()
            }
    }

    private func startShakeIfNeeded() {
        if isShaky {
            shakeOffset = 0
            withAnimation(
                .easeInOut(duration: 0.06)
                    .repeatForever(autoreverses: true)
            ) {
                shakeOffset = 4
            }
        } else {
            shakeOffset = 0
        }
    }
}
