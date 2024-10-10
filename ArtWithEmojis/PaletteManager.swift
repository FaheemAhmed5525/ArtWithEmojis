//
//  PaletteManager.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 10/10/2024.
//

import SwiftUI

struct PaletteManager: View {
    let stores: [PaletteStore]
    
    @State private var selectedStore: PaletteStore?
    var body: some View {
        NavigationSplitView {
            List(stores, selection: $selectedStore) { store in
                Text(store.name)//bad!!
                    .tag(store)
            }
        } content: {
            if let selectedStore {
                EditablePaletteList(store: selectedStore)
            }
        } detail: {
             Text("Choose a store")
        }
    }
}

//#Preview {
//    PaletteManager()
//}
