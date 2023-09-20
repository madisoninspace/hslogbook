//
//  Path.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Foundation
import SwiftUI

class Path: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    static let shared: Path = Path()
}
