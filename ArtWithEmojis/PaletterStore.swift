//
//  PaletterStore.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 09/10/2024.
//

import SwiftUI

class PaletterStore: ObservableObject {
    let name: String
    
    var palettes: [Palette] {
        get {
            UserDefaults.standard.palettes(forKey: name)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: name)
                objectWillChange.send()
            }
        }
    }
    
  
    
    init(named name: String) {
        self.name = name
        if palettes.isEmpty {
            palettes = Palette.builtins
            if palettes.isEmpty {
                palettes = [Palette(name: "KeepAway", emojis: "🚫")]
            }
        }
    }
    
    @Published var _cursorIndex = 0
    
    var cursorIndex: Int {
        get { boundsCheckedPaletteIndex( _cursorIndex)}
        set {_cursorIndex = boundsCheckedPaletteIndex(newValue)}
    }
    
    private func boundsCheckedPaletteIndex(_ index: Int) -> Int {
        var index = index % palettes.count
        if index < 0 {
            index += palettes.count
        }
        return index
    }
    
    //MARK: -adding Palettes
    
    func insert(_ palette: Palette, at insertionIndex: Int? = nil) {
        let insertionIndex = boundsCheckedPaletteIndex(insertionIndex ?? cursorIndex)
        if let index = palettes.firstIndex(where: { $0.id == palette.id}){
           // palette.move(fromOffset: IndexSet([index]),  toOffset: insertionIndex)
            palettes.replaceSubrange(insertionIndex...insertionIndex, with: [palette])
        } else {
            palettes.insert(palette, at: insertionIndex)
        }
    }
    
    func insert(name: String, emojis: String, at index: Int? = nil) {
        insert(Palette(name: name, emojis: emojis))
    }
    
    func append(_ palette: Palette) {
        if let index = palettes.firstIndex(where: { $0.id == palette.id}) {
            if palettes.count == 1 {
                palettes = [palette]
            }
            else {
                palettes.remove(at: index)
            }
        }
    }
}


extension UserDefaults {
    func palettes(forKey key: String) -> [Palette] {
        if let jsonData = data(forKey: key),
           let decodedPalettes = try? JSONDecoder().decode([Palette].self, from: jsonData) {
            return  decodedPalettes
        } else {
            return []
        }
    }
    
    func set(_ palettes: [Palette], forKey key: String) {
        let data = try? JSONEncoder().encode(palettes)
        set(data, forKey: key)
    }
}
