import SwiftUI

// MARK: - Button styles

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
                                gradient: Gradient(colors: [
                                    Color(red: 0.68, green: 0.91, blue: 1.0),
                                    Color(red: 0.18, green: 0.55, blue: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.85),
                                    Color.white.opacity(0.0)
                                ]),
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
                            gradient: Gradient(colors: [
                                Color(red: 0.97, green: 0.98, blue: 0.99),
                                Color(red: 0.87, green: 0.90, blue: 0.93)
                            ]),
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

// MARK: - Quiz view

struct QuizView: View {
    @StateObject private var engine = QuizEngine()

    private enum ResultPhase {
        case none        // still answering questions
        case intro1      // "phew, i think i got a good reading on you!"
        case intro2      // "now before you get hangry..."
        case reveal      // final result shown
    }

    @State private var resultPhase: ResultPhase = .none
    @State private var showExplosion = false

    var body: some View {
        ZStack {
            // Main content: either quiz or result dialogue
            if resultPhase == .none {
                questionView
            } else {
                resultSequenceView
            }

            // Explosion GIF overlay (centered above cat)
            if showExplosion {
                ExplosionGifView(gifName: "explosion") {
                    showExplosion = false
                }
                .frame(width: 260, height: 260)
                .offset(y: -40)
                .allowsHitTesting(false)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .onChange(of: engine.result?.cuisine) { newValue in
            if newValue == nil {
                resultPhase = .none
            } else {
                // user just hit a leaf → start first dialogue bubble
                resultPhase = .intro1
            }
        }
        .animation(.easeInOut, value: engine.currentNode.id)
        .animation(.easeInOut, value: resultPhase)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showExplosion)
    }

    // MARK: - Question UI

    private var questionView: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 60)

            PixelSpeechBubble(
                text: engine.currentNode.question,
                isShaky: false
            )
            .frame(maxWidth: 320)

            VStack(spacing: 12) {
                ForEach(engine.currentNode.choices) { choice in
                    Button {
                        engine.choose(choice)
                    } label: {
                        Text(choice.label)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(WiiPrimaryButtonStyle())
                }

                if engine.hasNeitherOption {
                    Button {
                        engine.chooseNeither()
                    } label: {
                        Text("Neither of these")
                            .font(.system(size: 14, weight: .regular))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(WiiSecondaryButtonStyle())
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }

    // MARK: - Result dialogue + reveal

    private var resultSequenceView: some View {
        VStack(spacing: 18) {
            Spacer().frame(height: 80)   // keep UI above the cat

            Group {
                switch resultPhase {
                case .intro1:
                    PixelSpeechBubble(
                        text: "phew, i think i got a good reading on you!",
                        isShaky: false
                    )
                    .frame(maxWidth: 320)

                case .intro2:
                    PixelSpeechBubble(
                        text: "now before you get hangry, what i think you're craving is...",
                        isShaky: true          // this one shakes with drumroll
                    )
                    .frame(maxWidth: 320)

                case .reveal:
                    if let result = engine.result {
                        VStack(spacing: 16) {
                            Text(result.cuisine)
                                .font(.system(size: 30, weight: .heavy))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.6),
                                        radius: 8, x: 0, y: 4)

                            Button {
                                SoundManager.shared.play(.click)
                                engine.restart()
                                resultPhase = .none
                            } label: {
                                Text("Try again")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(WiiSecondaryButtonStyle())
                            .padding(.horizontal, 64)
                        }
                    } else {
                        EmptyView()
                    }

                case .none:
                    EmptyView()
                }
            }

            Spacer()
        }
        .contentShape(Rectangle())   // tap anywhere to advance
        .onTapGesture {
            advanceResultPhase()
        }
    }

    private func advanceResultPhase() {
        guard engine.result != nil else { return }

        switch resultPhase {
        case .intro1:
            resultPhase = .intro2
            SoundManager.shared.play(.drumroll)   // shaky line + drumroll

        case .intro2:
            resultPhase = .reveal
            // 💥 play explosion SFX and show GIF once
            SoundManager.shared.play(.resultExplosion)
            showExplosion = true

        case .reveal, .none:
            break
        }
    }
}
