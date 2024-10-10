//
//  PaletteList.swift
//  ArtWithEmojis
//
//  Created by Faheem Ahmed on 10/10/2024.
//

import SwiftUI

struct EditablePaletteList: View {
    
    @ObservedObject var store: PaletteStore
    @State private var showCursorPalette = false
    
    
    var body: some View {
        List {
            ForEach(store.palettes) { palette in
                NavigationLink(value: palette.id) {
                    VStack(alignment: .leading) {
                        Text(palette.name)
                        Text(palette.emojis).lineLimit(1)
                    }
                }
                .navigationDestination(for: Palette.ID.self) {paletteId in
                    if let index = store.palettes.firstIndex(where: { $0.id == paletteId }) {
                        PaletteEditor(palette: $store.palettes[index])
                    }
                }
                .navigationDestination(isPresented: $showCursorPalette) {
                    PaletteEditor(palette: $store.palettes[store.cursorIndex])
                }
                .navigationTitle("\(store.name) palettes")
            }
            .onDelete { indexSet in
                withAnimation {
                    store.palettes.remove(atOffsets: indexSet)
                }
            }
            .onMove { indexSet, newOffset in
                store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
                
            }
        }
        .toolbar {
            Button {
                store.insert(name: "", emojis: "")
                showCursorPalette = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

struct PaletteList: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        NavigationStack {
            List(store.palettes) { palette in
                NavigationLink(value: palette) {
                    Text(palette.name)
                }
                .navigationDestination(for: Palette.self) {_ in 
                    PaletteView(palette: palette)
                }
                .navigationTitle("\(store.name) palettes")
                
            }
        }
    }
}

struct PaletteView: View {
    let palette: Palette
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(palette.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                }
            }
            .navigationDestination(for: String.self) { emoji in
                Text(emoji).font(.system(size: 300))
            }
            Spacer()
        }
        .padding()
        .font(.largeTitle)
        .navigationTitle(palette.name)
    }
}

#Preview {
    PaletteList()
}
