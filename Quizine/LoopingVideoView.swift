import SwiftUI
import AVFoundation

// UIKit view that plays a looping video and always fills its bounds
final class LoopingVideoBackgroundView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var looper: AVPlayerLooper?
    private let queuePlayer = AVQueuePlayer()

    init(videoName: String, fileExtension: String = "mp4") {
        super.init(frame: .zero)

        backgroundColor = .black
        layer.addSublayer(playerLayer)

        guard let url = Bundle.main.url(forResource: videoName, withExtension: fileExtension) else {
            print("⚠️ Could not find video \(videoName).\(fileExtension)")
            return
        }

        let item = AVPlayerItem(url: url)
        looper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        queuePlayer.isMuted = true
        queuePlayer.play()

        playerLayer.player = queuePlayer
        playerLayer.videoGravity = .resizeAspectFill   // <- fill + crop, no bars
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

// SwiftUI wrapper
struct LoopingVideoView: UIViewRepresentable {
    let videoName: String

    func makeUIView(context: Context) -> LoopingVideoBackgroundView {
        LoopingVideoBackgroundView(videoName: videoName)
    }

    func updateUIView(_ uiView: LoopingVideoBackgroundView, context: Context) {
        // nothing to update
    }
}
