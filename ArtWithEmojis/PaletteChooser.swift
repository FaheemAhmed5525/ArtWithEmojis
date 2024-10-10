//
//  PaletteChooser.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 09/10/2024.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var store = PaletterStore
    
    @State private var shwoPaletteEditor = false
    
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
//                .popover(isPresented: $shwoPaletteEditor) {
//                    PaletteEditor()
//                }
        }
        .clipped()
        .sheet(isPresented: $shwoPaletteEditor) {
            PaletteEditor(palette: $store.palettes[store.cursorIndex])
                .font(nil)
        }
    }
    
    private var gotoMenu: some View {
        Menu {
            ForEach(store.palettes) { palette in
                AnimatedActionButton(palette.name) {
                    if let index = $store.palettes.firstIndex(where: { $0.id == palette.id }) {
                        store.cursorIndex = index
                    }
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
        }
    }
    
    
    private var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            withAnimation {
                store.cursorIndex += 1
            }
        }
        .contextMenu {
            gotoMenu
            AnimatedActionButton("New", systemImage: "plus.circle") {
                store.insert(name: "Math", emojis: "+-*/??")
            }
            AnimatedActionButton("Delete" ,systemImage: "minus.circle",  role: .destructive ) {
                store.palettes.remove(at: store.cursorIndex)
            }
            AnimatedActionButton("Edit", systemImage: "pencil") {
                shwoPaletteEditor = true
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
