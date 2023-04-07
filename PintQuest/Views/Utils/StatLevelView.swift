//
//  StatLevelView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import SwiftUI

struct StatLevelView: View {
    
    private enum Constants {
        static let defaultColor: Color = .darkBrown
        static let range: ClosedRange<Double> = 1...5
    }
    
    var statKind: BeerVitalStats
    var value: Double?
    var color: Color = Constants.defaultColor
    var horizontal: Bool = false
    
    var body: some View {
        if horizontal {
            HStack {
                label
                result
            }
        } else {
            VStack(alignment: .leading, spacing: 5.0) {
                label
                result
            }
        }
    }
    
    private var label: some View {
        Text(statKind.shortName)
            .font(.subheadline)
            .fontWeight(.medium)
    }
    
    private var result: some View {
        ZStack {
            if let icon = statKind.icon {
                HStack(spacing: 4.0) {
                    ForEach(1...5, id: \.self) { index in
                        icon
                            .font(.caption2)
                            .foregroundColor(value?.scale(from: statKind.range, to: Constants.range) ?? 0.0 >= Double(index) ? color : .gray.opacity(0.5))
                    }
                }
            } else {
                HStack(spacing: .zero) {
                    Text(value ?? 0.0, format: .number)
                    Text("%")
                }
                .font(.system(size: 12.0))
                .fontWeight(.semibold)
                .foregroundColor(color)
            }
        }
    }
}

struct StatLevelView_Previews: PreviewProvider {
    static var previews: some View {
        StatLevelView(statKind: .ibu,
                      value: 80.4)
    }
}
