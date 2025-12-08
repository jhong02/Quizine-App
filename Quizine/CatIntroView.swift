import SwiftUI

struct CatIntroView: View {

    /// Called when the intro dialogue finishes
    let onFinished: () -> Void

    struct IntroLine {
        let text: String
        let isShaky: Bool
    }

    // Script the cat says before the quiz
    private let lines: [IntroLine] = [
        IntroLine(text: "oh hello there!", isShaky: false),
        IntroLine(text: "my name is leche, and my job is to guess what you're craving", isShaky: false),
        IntroLine(text: "my accuracy is always 100%", isShaky: false),
        IntroLine(text: "but if i'm wrong feel free to take a bite out of me", isShaky: false),
        IntroLine(text: "(NOT TOO BIG PLEASE!!)", isShaky: true),   // shaky bubble
        IntroLine(text: "ok, let's get started shall we!", isShaky: false),
    ]

    @State private var currentIndex: Int = 0

    private var currentLine: IntroLine {
        lines[currentIndex]
    }

    var body: some View {
        GeometryReader { geo in
            let maxBubbleWidth = min(geo.size.width * 0.85, 320)

            VStack {
                Spacer()
                    .frame(height: geo.size.height * 0.22)

                PixelSpeechBubble(
                    text: currentLine.text,
                    isShaky: currentLine.isShaky
                )
                .id(currentLine.text)                      // re-mount for shake
                .frame(maxWidth: maxBubbleWidth)           // keep inside screen
                .onAppear {
                    if currentLine.isShaky {
                        SoundManager.shared.play(.shocked)
                    }
                }
                .onChange(of: currentIndex) { newValue in
                    if lines[newValue].isShaky {
                        SoundManager.shared.play(.shocked)
                    }
                }

                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .contentShape(Rectangle())
            .onTapGesture {
                advanceDialogue()
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Logic

    private func advanceDialogue() {
        SoundManager.shared.play(.click)

        if currentIndex < lines.count - 1 {
            currentIndex += 1
        } else {
            onFinished()
        }
    }
}
