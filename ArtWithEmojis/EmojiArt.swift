//
//  EmojiArt.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 07/10/2024.
//

import Foundation


struct EmojiArt {
    var background: URL?
    private(set)var emojis = [Emoji]()
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
        uniqueEmojiId += 1
        emojis.append(Emoji(
            string: emoji,
            position: position,
            size: size,
            id: uniqueEmojiId
        ))
    }
    
    struct Emoji: Identifiable {
        let string: String
        var position: Position
        var size: CGFloat
        var id: Int
        
        struct Position {
            var x: Int
            var y: Int
        }
    }
}
