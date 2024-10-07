//
//  EmojiArtDocumentView.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 07/10/2024.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    private let emojis = "😆😀😂☠️👿👮‍♀️🚶‍♀️🕺🏃‍♀️👕🕶️👜🧢🐼🐧🐦🐳🐟🐄🌹🌷☘️🔥🍏🍢🏓🪀⚽🏒🚗🚎🚛🚜🚲🏍️🚔🚍🚥🚂🚦🌄🕌🌌🌃⌚📱💻🕹️📷⏰📌✏️❤️💚⚫💭"
    private let paletEmojiSize: CGFloat = 60
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            
            ScrollingEmojis(emojis)
                .font(.system(size: paletEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray
                //image
                ForEach(document.emojis) {emoji in
                    Text(emoji.string)
                        .font(emoji.font)
                        .position(emoji.position.in(geometry))
                }
            }
        }
    }
}

 

struct ScrollingEmojis: View {
    let emojis: [String]
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                }
            }
        }
    }
}

#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
}
