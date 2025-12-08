import SwiftUI
import UIKit
import ImageIO

// Wraps a bundled GIF and plays it once
struct ExplosionGifView: UIViewRepresentable {
    let gifName: String
    let onFinished: (() -> Void)?

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        playGif(on: imageView)
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        // nothing to update for now
    }

    private func playGif(on imageView: UIImageView) {
        guard let url = Bundle.main.url(forResource: gifName, withExtension: "gif"),
              let data = try? Data(contentsOf: url),
              let source = CGImageSourceCreateWithData(data as CFData, nil)
        else {
            print("ExplosionGifView: missing gif \(gifName)")
            return
        }

        let frameCount = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var duration: Double = 0

        for i in 0..<frameCount {
            if let cg = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cg))
            }

            if let props = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
               let gifDict = props[kCGImagePropertyGIFDictionary as String] as? [String: Any] {

                let delay = (gifDict[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double)
                         ?? (gifDict[kCGImagePropertyGIFDelayTime as String] as? Double)
                         ?? 0.1
                duration += delay
            } else {
                duration += 0.1
            }
        }

        imageView.animationImages = images
        imageView.animationDuration = duration
        imageView.animationRepeatCount = 1
        imageView.startAnimating()

        if let onFinished {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                onFinished()
            }
        }
    }
}
