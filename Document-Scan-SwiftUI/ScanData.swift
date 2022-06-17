//
//  ScanData.swift
//  Document-Scan-SwiftUI
//
//  Created by Isaí on 17/06/22.
//

import Foundation


struct ScanData: Identifiable {
    var id = UUID()
    let content: String
    
    init(content: String){
        self.content = content
    }
    
}
