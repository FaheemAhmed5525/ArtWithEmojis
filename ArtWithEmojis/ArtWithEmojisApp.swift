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
    @StateObject var paletteStore = PaletteStore(named: "Main")
    @StateObject var store2 = PaletteStore(named: "Store")
    @StateObject var store3 = PaletteStore(named: "Store")
    @StateObject var store4 = PaletteStore(named: "Store")

    var body: some Scene {
        WindowGroup {
            PaletteManager(stores: [paletteStore, store2, store3, store4])
//            EmojiArtDocumentView(document: defaultDocument)
        }
        .environmentObject(paletteStore)
    }
}
