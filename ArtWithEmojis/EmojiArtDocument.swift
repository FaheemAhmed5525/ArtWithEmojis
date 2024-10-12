//
//  EmojiArtDocument.swift
//  ArtWithEmojis
//
//  Created by Faheem Ahmed on 07/10/2024.
//

import SwiftUI
import UniformTypeIdentifiers

class EmojiArtDocument: ReferenceFileDocument {
    
    @Environment(\.undoManager) var undoManager
    
    func snapshot(contentType: UTType) throws -> Data {
        try emojiArt.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
    
//    typealias Snapshot = Data
    
    static var readableContentTypes: [UTType] {
        [.emojiart]
    }
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            emojiArt = try EmojiArt(json: data)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
//            autoSave()
            if emojiArt.background != oldValue.background {
                Task {
                    await fatchBackgroundImage()
                }
            }
        }
    }
    private let autoSaveURL: URL = URL.documentsDirectory.appendingPathComponent("Autosaved.emojiart")
    
//    
//    private func autoSave() {
//        save(to: autoSaveURL)
//        print("Autoseved to \(autoSaveURL)")
//    }
//    
//    
//    private func save(to url: URL) {
//        do {
//            let data = try emojiArt.json()
//            try data.write(to: url)
//        } catch let error {
//            print("Error while saving document: \(error.localizedDescription)")
//        }
//    }
    
    init() {
        
//        if let data = try? Data(contentsOf: autoSaveURL),
//           let autoSavedEmojiArt = try? EmojiArt(json: data) {
//            emojiArt = autoSavedEmojiArt
//        }
        emojiArt.addEmoji("☀️", at: .init(x: 400, y: 520), size: 200)
        emojiArt.addEmoji("🍀", at: .init(x: -300, y: -520), size: 230)
    }
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var bbox: CGRect {
        var bbox = CGRect.zero
        for emoji in emojiArt.emojis {
            bbox = bbox.union(emoji.bbox)
        }
        if let backgroundSize = background.uiImage?.size {
            bbox = bbox.union(CGRect(center: .zero, size: backgroundSize))
        }
        return bbox
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
                _ = try await fetchUIImage(from: url)
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
        if UIImage(data: data) != nil {
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
    
    private func undoableyPerform(_ action: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
        let oldEmojiArt = emojiArt
        doit()
        undoManager?.registerUndo(withTarget: self) { myself in
            myself.undoableyPerform(action, with: undoManager) {
                myself.emojiArt = oldEmojiArt
            }
        }
        
        
        undoManager?.setActionName(action)
    }
    
    func setBackground(_ url: URL?, undoWith undoManager: UndoManager? = nil) {
        undoableyPerform("Set Background", with: undoManager) {
            emojiArt.background = url
        }
    }
    
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat, undoWith undoManager: UndoManager? = nil) {
        undoableyPerform("Add \(emoji)", with: undoManager) {
            emojiArt.addEmoji(emoji, at: position, size: size)
        }
    }
}
    
extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
    var bbox: CGRect {
        CGRect(
            center: position.in(nil),
            size: CGSize(width: CGFloat(size), height: CGFloat(size)))
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy?) -> CGPoint {
        let center = geometry?.frame(in: .local).center ?? .zero
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}

extension UTType {
    static let emojiart = UTType(exportedAs: "CrossStart.FaheemAhmed5525")
}
