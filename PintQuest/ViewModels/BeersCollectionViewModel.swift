//
//  BeersCollectionViewModel.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import Foundation

@MainActor
class BeersCollectionViewModel: ObservableObject {
    
    @Published var beers: [Beer] = []
    @Published var selectedTab: MenuTab = .browse
    
    init() { }
    
    func fetchBeers() async {
        do {
            beers = try await selectedTab.viewModel.fetchBeers().value
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
}
