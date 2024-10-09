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
                
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
                }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            
            .dropDestination(for: StrURLData.self ) { strURLData, location in
                return drop(strURLData, at: location, in: geometry)
            }
            
        }
    }
    
    
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero//.init(width: 100, height: 100)
    
    @GestureState private var gestureZoom: CGFloat = 1
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($gestureZoom) { inMotionValue, gestureZoom, _ in
                gestureZoom = inMotionValue
            }
            .onEnded { value in
                zoom *= value
            }
    }
    
    @GestureState private var gesturePan: CGSize = .zero
    private var panGesture: some Gesture {
        DragGesture()
            .updating($gesturePan) { value, gesturePan, _ in
                gesturePan = value.translation
            }
            .onEnded { value in
                pan += value.translation
            }
    }
    
    
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
            .position(emoji.position.in(geometry))}
    }
    
    private func drop(_ strURLDatas: [StrURLData], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for strURLData in strURLDatas {
            switch strURLData {
            case StrURLData.url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(
                    emoji,
                    at: emojiPosition(at: location, in: geometry),
                    size: paletEmojiSize / zoom
                )
                return true
            default:
                break
            }
        }
        return false
    }
    
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(
            x: Int(location.x - center.x),
            y: Int(-location.y - center.y))
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
                        .draggable(emoji)
                }
            }
        }
    }
}

#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
}
