//
//  SwitchPlacement.swift
//  Gateway
//
//  Created by Hannah Wass on 9/18/23.
//

import Foundation
import SwiftUI

func switchPlacement() -> ToolbarItemPlacement {
    #if os(macOS)
    return ToolbarItemPlacement.navigation
    #else
    return ToolbarItemPlacement.topBarLeading
    #endif
}
