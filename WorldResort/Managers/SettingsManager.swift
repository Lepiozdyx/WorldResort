//
//  SettingsManager.swift
//  WorldResort
//
//  Created by Alex on 14.04.2025.
//

import AVFoundation
import SwiftUI

@MainActor
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var isSoundOn: Bool {
        didSet {
            defaults.set(isSoundOn, forKey: "sound")
            
            if !isSoundOn && isMusicOn {
                isMusicOn = false
            }
        }
    }
    
    @Published var isMusicOn: Bool {
        didSet {
            defaults.set(isMusicOn, forKey: "music")
            
            if isMusicOn {
                if isSoundOn {
                    playMusic()
                } else {
                    isMusicOn = false
                }
            } else {
                stopMusic()
            }
        }
    }
    
    
    private let defaults = UserDefaults.standard
    private var audioPlayer: AVAudioPlayer?
    private var soundPlayer: AVAudioPlayer?
    
    private init() {
        self.isSoundOn = true
        self.isMusicOn = true
        
        if defaults.object(forKey: "sound") != nil {
            self.isSoundOn = defaults.bool(forKey: "sound")
        } else {
            defaults.set(true, forKey: "sound")
        }
        
        if defaults.object(forKey: "music") != nil {
            self.isMusicOn = defaults.bool(forKey: "music")
        } else {
            defaults.set(true, forKey: "music")
        }
        
        setupAudioSession()
        prepareMusic()
        prepareSound()
    }
    
    // MARK: - Methods
    func switchSound() {
        isSoundOn.toggle()
    }
    
    func switchMusic() {
        if !isSoundOn && !isMusicOn {
            return
        }
        isMusicOn.toggle()
    }
    
    func playSound() {
        guard isSoundOn, let player = soundPlayer else { return }
        player.currentTime = 0
        player.play()
    }
    
    func playMusic() {
        guard isSoundOn, isMusicOn, let player = audioPlayer, !player.isPlaying else { return }
        player.play()
    }
    
    func stopMusic() {
        audioPlayer?.pause()
    }
    
    // MARK: - Private Methods
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    private func prepareMusic() {
        guard let url = Bundle.main.url(
            forResource: GameConstants.music,
            withExtension: GameConstants.format
        ) else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func prepareSound() {
        guard let url = Bundle.main.url(
            forResource: GameConstants.sound,
            withExtension: GameConstants.format
        ) else { return }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - View Extension
struct SoundViewModifier: ViewModifier {
    @StateObject private var manager = SettingsManager.shared
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                manager.playSound()
            }
    }
}

extension View {
    func soundView() -> some View {
        self.modifier(SoundViewModifier())
    }
}

// MARK: - Button Extension
struct SoundButtonModifier: ButtonStyle {
    @StateObject private var manager = SettingsManager.shared
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    manager.playSound()
                }
            }
    }
}

extension Button {
    func soundButton() -> some View {
        self.buttonStyle(SoundButtonModifier())
    }
}
