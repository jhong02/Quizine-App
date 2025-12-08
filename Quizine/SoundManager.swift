import Foundation
import AVFoundation

// All one-shot sound effects
enum SoundEffect: String {
    case click
    case shocked
    case drumroll
    case resultExplosion
}

// Background music tracks
enum BackgroundTrack: String {
    case quizMusic = "quiz-music"
}

final class SoundManager {

    static let shared = SoundManager()

    private var sfxPlayers: [SoundEffect: AVAudioPlayer] = [:]
    private var musicPlayer: AVAudioPlayer?

    private init() {
        setUpSession()

        // SFX files should live in the "sounds" group
        loadSFX(.click,           baseName: "click")
        loadSFX(.shocked,         baseName: "shocked")
        loadSFX(.drumroll,        baseName: "drumroll")
        loadSFX(.resultExplosion, baseName: "result-explosion", volume: 0.2) // softer boom
    }

    // MARK: - Public SFX

    func play(_ effect: SoundEffect) {
        guard let player = sfxPlayers[effect] else {
            print("SoundManager: no SFX for \(effect)")
            return
        }
        player.currentTime = 0
        player.play()
    }

    // MARK: - Background music

    func playQuizMusic(volume: Float = 0.4) {
        // reuse existing player if we already loaded it
        if let player = musicPlayer {
            player.currentTime = 0
            player.volume = volume
            player.play()
            return
        }

        guard let player = loadMusic(baseName: BackgroundTrack.quizMusic.rawValue) else {
            print("SoundManager: quiz music missing")
            return
        }

        player.numberOfLoops = -1
        player.volume = volume
        musicPlayer = player
        player.play()
    }

    func stopQuizMusic() {
        musicPlayer?.stop()
    }

    // MARK: - Setup

    private func setUpSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("SoundManager: audio session error: \(error)")
        }
    }

    // MARK: - Loading helpers

    private func loadSFX(_ effect: SoundEffect, baseName: String, volume: Float = 1.0) {
        let exts = ["wav", "mp3", "m4a", "caf"]

        for ext in exts {
            if let url = Bundle.main.url(forResource: baseName, withExtension: ext) {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.volume = volume
                    player.prepareToPlay()
                    sfxPlayers[effect] = player
                    return
                } catch {
                    print("SoundManager: failed SFX \(baseName).\(ext): \(error)")
                }
            }
        }

        print("SoundManager: SFX \(baseName) not found")
    }

    private func loadMusic(baseName: String) -> AVAudioPlayer? {
        let exts = ["mp3", "m4a", "caf", "wav"]

        for ext in exts {
            if let url = Bundle.main.url(forResource: baseName, withExtension: ext) {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    return player
                } catch {
                    print("SoundManager: failed music \(baseName).\(ext): \(error)")
                }
            }
        }

        print("SoundManager: music \(baseName) not found")
        return nil
    }
}
