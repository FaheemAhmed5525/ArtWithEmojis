//
//  EmojiArtDocument.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 07/10/2024.
//

import SwiftUI


class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt()
    
    init() {
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
