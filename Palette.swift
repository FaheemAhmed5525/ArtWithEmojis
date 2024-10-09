//
//  Palette.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 09/10/2024.
//

import Foundation

struct Palette: Identifiable {
    var name: String
    var emojis: String
    let id = UUID()
    
    static let builtins =
    Palette(name: "Vehicles")
}
