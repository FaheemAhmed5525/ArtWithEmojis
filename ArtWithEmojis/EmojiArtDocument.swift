//
//  EmojiArtDocument.swift
//  ArtWithEmojis
//
//  Created by Faheem Ahmed on 07/10/2024.
//

import SwiftUI


class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
            autoSave()
            if emojiArt.background != oldValue.background {
                Task {
                    await fatchBackgroundImage()
                }
            }
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
    
//    var background: URL? {
//        emojiArt.background
//    }
    
    @Published  var background: Background = .none
    
    
    //MARK: -Background
    
    @MainActor
    private func fatchBackgroundImage() async {
        if let url = emojiArt.background {
            background = .fatching(url)
            do {
                let image = try await fetchUIImage(from: url)
                if url == emojiArt.background {
                    background = .found(try await fetchUIImage(from: url))
                }
            } catch {
                background = .failed("Could't set background: \(error.localizedDescription)")
            }
            background = .failed("Error message")
        } else {
            background = .none
        }
    }

    private func fetchUIImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let uiImage = UIImage(data: data) {
            return UIImage(data: data)!
        } else {
            throw FetchError.badImageData
        }
    }
    
    
    enum FetchError: Error {
        case badImageData
    }
    
    enum Background {
        case none
        case fatching(URL)
        case found(UIImage)
        case failed(String)
        
        var uiImage: UIImage? {
            switch self {
            case .found(let uiImage): return uiImage
            default: return nil
            }
        }
        
        var urlBeingFatched: URL? {
            switch self {
            case .fatching(let url): return url
            default: return nil
            }
        }
        
        var isFatching: Bool {
            urlBeingFatched != nil
        }
        
        var failureReason: String {
            switch self {
            case .failed(let reason): return reason
            default: return ""
            }
        }
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
