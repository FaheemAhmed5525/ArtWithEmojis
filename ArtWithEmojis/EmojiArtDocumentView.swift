//
//  EmojiArtDocumentView.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 07/10/2024.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
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
                
                AsyncImage(url: document.background)
                    .position(Emoji.Position.zero.in(geometry))
                
                ForEach(document.emojis) {emoji in
                    Text(emoji.string)
                        .font(emoji.font)
                        .position(emoji.position.in(geometry))
                }
            }
            .dropDestination(for: URL.self ) { urls, location in
                return drop(urls, at: location, in: geometry)
            }
        }
    }
    
    private func drop(_ urls: [URL], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        if let url = urls.first {
            document.setBackground(url)
            return true
        }
        else {
            return false
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
