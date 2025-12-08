import SwiftUI

struct QuizView: View {
    @StateObject private var engine = QuizEngine()

    private enum ResultPhase {
        case none        // answering questions
        case intro1      // "phew, i think i got a good reading on you!"
        case intro2      // "now before you get hangry..."
        case reveal      // final result text
    }

    @State private var resultPhase: ResultPhase = .none
    @State private var showExplosion = false

    var body: some View {
        ZStack {
            if resultPhase == .none {
                questionView
            } else {
                resultSequenceView
            }

            // Big explosion overlay
            if showExplosion {
                ExplosionGifView(gifName: "explosion") {
                    showExplosion = false
                }
                .frame(
                    width: UIScreen.main.bounds.width * 0.95,
                    height: UIScreen.main.bounds.height * 0.95
                )
                .offset(y: -20)
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
                // finished a leaf → start first result bubble
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

    // MARK: - Result flow

    private var resultSequenceView: some View {
        VStack(spacing: 18) {
            Spacer().frame(height: 80)   // keeps stuff above the cat

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
                        isShaky: true
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
        // tap anywhere to step through the result phases
        .contentShape(Rectangle())
        .onTapGesture {
            advanceResultPhase()
        }
    }

    private func advanceResultPhase() {
        guard engine.result != nil else { return }

        switch resultPhase {
        case .intro1:
            resultPhase = .intro2
            SoundManager.shared.play(.drumroll)

        case .intro2:
            resultPhase = .reveal
            // explosion sound is already quieter in SoundManager
            SoundManager.shared.play(.resultExplosion)
            showExplosion = true

        case .reveal, .none:
            break
        }
    }
}
