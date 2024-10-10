//
//  PaletteChooser.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 09/10/2024.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var store = PaletterStore(named: "Main")
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()
    }
    
    var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            withAnimation {
                store.cursorIndex += 1
            }
        }
        .contextMenu {
            AnimatedActionButton("New", systemImage: "plus.circle") {
                store.insert(name: "Math", emojis: "+-*/??")
            }
            AnimatedActionButton("Delete" ,systemImage: "minus.circle",  role: .destructive ) {
                store.palettes.remove(at: store.cursorIndex)
            }
        }
    }
    
    func view(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
        .id(palette.id)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
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
    PaletteChooser()
        .environmentObject(PaletterStore(named: "Preview"))
}
