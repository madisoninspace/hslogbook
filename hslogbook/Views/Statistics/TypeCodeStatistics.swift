//
//  TypeCodeStatistics.swift
//  hslogbook
//
//  Created by Hannah Wass on 9/19/23.
//  Copyright © 2023 Hannah L. Wass. All rights reserved.
//

import Charts
import SwiftData
import SwiftUI

struct TypeCodeStatistics: View {
    @Query(sort: [
        SortDescriptor(\TypeCode.manufacturer),
        SortDescriptor(\TypeCode.model),
    ], animation: .smooth) private var codes: [TypeCode]
    
    var body: some View {
        Chart {
            ForEach(codes.sorted(by: { $0.code < $1.code }).filter({$0.airplanes?.count ?? 0 > 0})) { fc in
                SectorMark(angle: .value("Count", fc.airplanes?.count ?? 0))
                    .foregroundStyle(by: .value("Type", fc.code))
                    .annotation(position: .overlay) {
                        VStack {
                            Text(fc.code)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.white)
                            Text("\(fc.airplanes?.count ?? 0)")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
            }
        }
        .padding()
    }
}

#Preview {
    TypeCodeStatistics()
}
