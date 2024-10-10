//
//  EmojiArt.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 07/10/2024.
//

import Foundation


struct EmojiArt: Codable{
    var background: URL?
    private(set)var emojis = [Emoji]()
    
    func json() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    init(json: Data) throws{
        self = try JSONDecoder().decode(EmojiArt.self, from: json)
    }
    
    init() {
        
    }
    
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
    
    struct Emoji: Identifiable, Codable {
        let string: String
        var position: Position
        var size: CGFloat
        var id: Int
        
        struct Position: Codable {
            var x: Int
            var y: Int
            
            static let zero = Self(x: 0, y: 0)
        }
    }
}
