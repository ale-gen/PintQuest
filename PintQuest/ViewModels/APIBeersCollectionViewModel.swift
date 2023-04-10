//
//  APIBeersCollectionViewModel.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import Foundation

class APIBeersCollectionViewModel: ObservableObject {
    
    private enum Constants {
        static let initialPage: Int = 1
        static let maxPageSize: Int = 25
    }
    
    @Published var beers: [Beer] = []
    private(set) var loaded: Bool
    private let client: PunkAPIClient
    private let beersOnPage: Int
    private var currentPage: Int
    private var expectNextPage: Bool
    
    init(client: PunkAPIClient) {
        self.client = client
        self.beersOnPage = Constants.maxPageSize
        self.currentPage = Constants.initialPage
        self.expectNextPage = true
        self.loaded = false
    }
    
    @MainActor
    func getBeers() {
        Task {
            beers = try await client.getData(currentPage)
            loaded = true
        }
    }
    
    @MainActor
    func getBeersByName(_ name: String) {
        Task {
            beers = try await client.getDataByName(name, currentPage)
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
    
    func resetPagination() {
        currentPage = Constants.initialPage
    }
}
