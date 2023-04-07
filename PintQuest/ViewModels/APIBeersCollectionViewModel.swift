//
//  APIBeersCollectionViewModel.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import Foundation

class APIBeersCollectionViewModel: ObservableObject {
    
    @Published var beers: [Beer] = []
    private let client: PunkAPIClient
    private let beersOnPage: Int
    private var currentPage: Int
    private var expectNextPage: Bool
    
    init(client: PunkAPIClient) {
        self.client = client
        self.beersOnPage = 25
        self.currentPage = 1
        self.expectNextPage = true
    }
    
    @MainActor
    func getBeers() {
        Task {
            beers = try await client.getData(currentPage)
        }
    }
    
    @MainActor
    func loadMoreContent(_ current: Beer) {
        Task {
            let thresholdIndex = beers.index(beers.endIndex, offsetBy: -1)
            guard thresholdIndex == current.id, expectNextPage else { return }
            do {
                currentPage += 1
                let fetchedBeers = try await client.getData(currentPage)
                expectNextPage = fetchedBeers.count < beersOnPage ? false : true
                beers.append(contentsOf: fetchedBeers)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
