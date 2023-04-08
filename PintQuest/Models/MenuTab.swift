//
//  MenuTab.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import Foundation

enum MenuTab: CaseIterable {
    case browse
    case fav
    
    var name: String {
        switch self {
        case .browse:
            return Localizable.browseMenuTabTitle.value
        case .fav:
            return Localizable.favouriteMenuTabTitle.value
        }
    }
}

