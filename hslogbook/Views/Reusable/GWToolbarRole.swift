//
//  GWToolbarRole.swift
//  Gateway
//
//  Created by Hannah Wass on 9/18/23.
//

import Foundation
import SwiftUI

struct GWToolbarRole: ViewModifier {
    @State var title: String
    
    func body(content: Content) -> some View {
        content
        #if os(macOS)
        .toolbarRole(.editor)
        #else
        .toolbarRole(.browser)
        #endif
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle(title)
    }
}
