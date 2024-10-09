//
//  StrURLData.swift
//  ArtWithEmojis
//
//  Created by Faheeam Ahmed on 08/10/2024.
//

import CoreTransferable

// A datatype that can represent string or url or a Data

enum StrURLData: Transferable {
    case string(String)
    case url(URL)
    case data(Data)
    
    init(url: URL) {
        if let imageData = url.dataSchemeImageData {
            self = .data(imageData)
        }
        else{
            self = .url(url)
        }
    }
    
    init(string: String) {
        if string.hasPrefix("http"), let url = URL(string: string) {
            self = .url(url)
        }
        else {
            self = .string(string)
        }
    }
    
    
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation { StrURLData(string: $0 ) }
        ProxyRepresentation { StrURLData(url: $0 ) }
        ProxyRepresentation { StrURLData.data($0) }
    }
}

// Extension to handle `data:` URLs
extension URL {
    var dataSchemeImageData: Data? {
        // Check if the URL scheme is "data"
        guard self.scheme == "data",
              let range = self.absoluteString.range(of: "base64,") else {
            return nil
        }
        
        // Extract the base64-encoded string
        let base64String = String(self.absoluteString[range.upperBound...])
        
        // Decode the base64 string into Data
        return Data(base64Encoded: base64String)
    }
}
