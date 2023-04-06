//
//  BeerVitalStats.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import SwiftUI

enum BeerVitalStats {
    case abv
    case ibu
    case ebc
    
    var fullName: String {
        switch self {
        case .abv:
            return "Alcohol by Volume in Beer"
        case .ibu:
            return "International Bittering Units"
        case .ebc:
            return "Standard of Color Measurement"
        }
    }
    
    var shortName: String {
        switch self {
        case .abv:
            return "Alcohol"
        case .ibu:
            return "Bitterness"
        case .ebc:
            return "Color"
        }
    }
    
    var range: ClosedRange<Double> {
        switch self {
        case .abv:
            return 0...100
        case .ibu:
            return 1...150
        case .ebc:
            return 1...85
        }
    }
    
    var icon: Image? {
        switch self {
        case .abv:
            return nil
        case .ibu:
            return Image(systemName: "bolt.fill")
        case .ebc:
            return Image(systemName: "circle.fill")
        }
    }
    
    
}
