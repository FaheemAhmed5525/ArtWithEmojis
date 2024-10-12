//
//  ArtWithEmojisApp.swift
//  ArtWithEmojis
//
//  Created by Faheem Ahmed on 07/10/2024.
//

import SwiftUI

@main

struct ArtWithEmojisApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Main")
    @StateObject var store2 = PaletteStore(named: "Store")

    var body: some Scene {
        DocumentGroup(newDocument: { EmojiArtDocument() }) { config in
              EmojiArtDocumentView(document: config.document)
                  .environmentObject(paletteStore) // Injecting the environment object here
          }
      }
}



