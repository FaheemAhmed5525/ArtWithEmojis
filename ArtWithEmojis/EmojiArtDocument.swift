//
//  EmojiArtDocument.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 07/10/2024.
//

import SwiftUI


class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
            autoSave()
        }
    }
    private let autoSaveURL: URL = URL.documentsDirectory.appendingPathComponent("Autosaved.emojiart")
    
    
    private func autoSave() {
        save(to: autoSaveURL)
        print("Autoseved to \(autoSaveURL)")
    }
    
    
    private func save(to url: URL) {
        do {
            let data = try emojiArt.json()
            try data.write(to: url)
        } catch let error {
            print("Error while saving document: \(error.localizedDescription)")
        }
    }
    
    init() {
        
        if let data = try? Data(contentsOf: autoSaveURL),
           let autoSavedEmojiArt = try? EmojiArt(json: data) {
            emojiArt = autoSavedEmojiArt
        }
        emojiArt.addEmoji("☀️", at: .init(x: 400, y: 520), size: 200)
        emojiArt.addEmoji("🍀", at: .init(x: -300, y: -520), size: 230)
    }
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var background: URL? {
        emojiArt.background
    }
    
    
    // MARK: - Intent
    
    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
        emojiArt.addEmoji(emoji, at: position, size: size)
    }
}
    
extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}
