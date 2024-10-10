//
//  ArtWithEmojisApp.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 07/10/2024.
//

import SwiftUI

@main

struct ArtWithEmojisApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletterStore(named: "Main")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
        }
        .environmentObject(paletteStore)
    }
}
