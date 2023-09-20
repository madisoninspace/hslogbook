//
//  FormTextField.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/20/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import SwiftUI

struct FormTextField: View {
    @State var title: String
    @Binding var content: String
    @State var min: Int = 1
    @State var max: Int = 255
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            
            if (content.count < min || content.count > max) {
                Image(systemName: "exclamationmark.triangle")
                    .symbolRenderingMode(.multicolor)
                    .symbolEffect(.pulse.wholeSymbol)
            }
            
            Spacer()
            
            TextField("", text: $content)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    FormTextField(title: "Manufacturer", content: .constant("Boeing"))
}
