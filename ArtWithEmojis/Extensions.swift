//
//  Extensions.swift
//  ArtApp
//
//  Created by Faheem Ahmed on 24/09/2024.
//

import SwiftUI

typealias CGOffset = CGSize

extension String {
    // removes the duplicates preserving order
    var uniqued: String {
        reduce(into: "") { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }}
    }
}


extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x-size.width/2, y: center.y - size.height/2), size: size)
    }
}

extension CGSize {
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs + rhs
    }
}

extension AnyTransition {
    static let rollUp: AnyTransition = .asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top))
    static let rollDown: AnyTransition = .asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom))
}


struct AnimatedActionButton: View {
    var title: String?  = nil
    var systemImage: String? = nil
    var role: ButtonRole?
    let action: () -> Void
    
    init(_ title: String? = nil, systemImage: String? = nil, role: ButtonRole? = nil , action: @escaping() -> Void ) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.action = action
    }
    
    var body: some View {
        Button(role: role) {
            withAnimation {
                action()
            }
        } label: {
            if let title, let systemImage {
                Label(title, systemImage: systemImage)
            } else if let title {
                Text(title)
            } else if let systemImage {
                Image(systemName: systemImage)
            }
        }
    }
}


struct UndoButton: View {
    @Environment(\.undoManager) var undoManager
    
    @State private var showUndoMenu = false
    
    var body: some View {
        if let undoManager {
            Image(systemName: "arrow.uturn.backward.circle")
                .foregroundColor(.accentColor)
                .onTapGesture {
                    undoManager.undo()
                }
                .onLongPressGesture {
                    showUndoMenu = true
                }
                .popover(isPresented: $showUndoMenu) {
                    VStack {
                        if !undoManager.canUndo, !undoManager.canRedo {
                            Text("Nothing to undo")
                        } else {
                            if undoManager.canUndo {
                                Button("Undo " + undoManager.undoActionName) {
                                    undoManager.undo()
                                    showUndoMenu = false
                                }
                            }
                            if undoManager.canRedo {
                                Divider()
                            }
                            Button("Redo " + undoManager.redoActionName) {
                                undoManager.redo()
                                showUndoMenu = false
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: 220)
                }
        }
    }
}
