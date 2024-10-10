//
//  PaletteEditor.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 10/10/2024.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette
    
    private let emojiFont = Font.system(size: 40)
    
    @State private var emojisToAdd: String = ""
    
    enum Focused {
        case name
        case addEmojis
    }
    
    @FocusState private var focused: Focused?
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $palette.name)
                    .focused($focused, equals: .name)
            }
            Section(header: Text("Emojis")) {
                Text("Add emojis here")
                    .font(emojiFont)
                    .focused($focused, equals: .addEmojis)
                    .onChange(of: emojisToAdd) { emojisToAdd in
                        palette.emojis = (emojisToAdd + palette.emojis)
                            //.filter{ $0.isEmoji}
                            .uniqued
                    }
                removeEmojis
            }
        }
            .frame(minWidth: 300, minHeight: 320)
            .onAppear {
                if palette.name.isEmpty {
                    focused = .name
                } else {
                    focused = .addEmojis
                }
            }
    }
    
    var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap to remove Emojis").font(.caption).foregroundColor(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 45))]) {
                ForEach(palette.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.remove(emoji.first!)
                                emojisToAdd.remove(emoji.first!)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
}

//#Preview {
//    
//    struct Preview: View {
//        @State private var palette = PaletteStore(named: "Preview").palettes.first!
//        
//        var body: some View {
//            PaletteEditor(palette: palette)
//        }
//    }
//    
//    var previews: some View {
//        Preview()
//    }
//   // PaletteEditor()
//}
