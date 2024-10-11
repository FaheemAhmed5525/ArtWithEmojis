//
//  EmojiArtDocumentView.swift
//  ArtWithEmojis
//
//  Created by Faheem Ahmed on 07/10/2024.
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
            
            PaletteChooser()
                .font(.system(size: paletEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                
                if document.background.isFatching {
                    ProgressView()
                        .scaleEffect(2)
                        .tint(.blue)
                        .position(Emoji.Position.zero.in(geometry))
                }
                Color.gray
                
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
                }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .onTapGesture(count: 2) {
                zoomToFit(document.bbox, in: geometry)
            }
            .dropDestination(for: StrURLData.self ) { strURLData, location in
                return drop(strURLData, at: location, in: geometry)
            }
            .onChange(of: document.background.failureReason) { reason in
                showBackgroundFailureAlert = (reason != nil)
            }
            .onChange(of: document.background.uiImage) { uiImage in
                zoomToFit(uiImage?.size, in: geometry)
                
            }
            .alert(
                "Set Background",
                isPresented: $showBackgroundFailureAlert,
                presenting: document.background.failureReason,
                actions: { reason in
                    Button("OK", role: .cancel) { }
                },
                message: { reason in
                    Text(reason)
                }
            )
        }
    }
    
    private func zoomToFit(_ size: CGSize?, in geometry: GeometryProxy) {
        if let size = size {
            zoomToFit(CGRect(center: .zero, size: size), in: geometry)
        }
    }
    
    private func zoomToFit(_ rect: CGRect, in geometry: GeometryProxy) {
        withAnimation {
            if rect.size.width > 0, rect.size.height > 0,
               geometry.size.width > 0, geometry.size.height > 0 {
                let hZoom = geometry.size.width / rect.size.width
                let vZoom = geometry.size.height / rect.size.height
                zoom = min(hZoom, vZoom)
                pan = CGOffset(
                    width: -rect.midX * zoom,
                    height: -rect.midY * zoom
                    )
            }
        }
    }
    
    @State private var showBackgroundFailureAlert = false
    
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
        if let uiImage = document.background.uiImage {
            Image(uiImage: uiImage)
                .position(Emoji.Position.zero.in(geometry))
        }
//        AsyncImage(url: document.background) { phase in
//            if let image = phase.image {
//                image
//            } else if let url = document.background {
//                if phase.error != nil {
//                    Text("\(url)")
//                } else {
//                    ProgressView()
//                }
//            }
//        }
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

 


#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
        .environmentObject(PaletteStore(named: "Preview"))
}
