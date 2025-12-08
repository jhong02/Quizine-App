import SwiftUI

struct StartView: View {
    @Environment(\.dismiss) private var dismiss

    private enum Stage {
        case loading
        case intro
        case quiz
    }

    @State private var stage: Stage = .loading

    var body: some View {
        ZStack {
            // Background video
            // Background video
            LoopingVideoView(videoName: "catpudding_idle")
                .ignoresSafeArea()
                .opacity(stage == .loading ? 0 : 1)

            // Foreground content
            switch stage {
            case .loading:
                ZStack {
                    Color.white.ignoresSafeArea()
                    LoadingBubbleView()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeInOut) {
                            stage = .intro
                        }
                    }
                }

            case .intro:
                CatIntroView {
                    withAnimation(.easeInOut) {
                        stage = .quiz
                    }
                }

            case .quiz:
                QuizView()
            }
        }
        // default back-chevron will show automatically now
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
        }
        .onAppear {
            // 70% quieter than before
            SoundManager.shared.playQuizMusic(volume: 0.12)
        }
        .onDisappear {
            SoundManager.shared.stopQuizMusic()
        }
    }
}
