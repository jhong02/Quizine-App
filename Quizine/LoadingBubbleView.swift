import SwiftUI

struct LoadingBubbleView: View {
    @State private var dotCount: Int = 1

    var body: some View {
        PixelSpeechBubble(
            text: "Starting" + String(repeating: ".", count: dotCount),
            isShaky: false
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                dotCount = 3
            }
        }
    }
}
