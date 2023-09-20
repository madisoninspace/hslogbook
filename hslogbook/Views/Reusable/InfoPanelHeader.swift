//
//  InfoPanelHeader.swift
//  Gateway
//
//  Created by Hannah Wass on 9/18/23.
//

import SwiftUI

struct InfoPanelHeader: View {
    @State var title: Text
    @State var subtext: Text
    
    var body: some View {
        HStack {
            title
                .font(.title)
                .bold()
            Spacer()
            subtext
                .font(.title3)
        }
        .padding([.leading, .trailing, .top])
    }
}

#Preview {
    InfoPanelHeader(title: Text("Airbus A321neo"), subtext: Text("\(Text("COUNT:").textScale(.secondary).foregroundStyle(.gray)) 1"))
}
