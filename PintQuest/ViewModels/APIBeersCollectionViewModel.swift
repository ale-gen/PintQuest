//
//  APIBeersCollectionViewModel.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import Foundation

struct APIBeersCollectionViewModel: FetchingDataViewModel {
    private let punkAPIClient: APIClient
    
    init(apiClient: APIClient) {
        self.punkAPIClient = apiClient
    }
    
    func fetchBeers() -> Task<[Beer], any Error> {
        Task {
            return try await punkAPIClient.fetchBeers()
        }
    }
    
    func fetchBeersByIds(_ ids: [Int64]) -> Task<[Beer], any Error> {
        Task {
            return try await punkAPIClient.fetchBeersByIds(ids)
        }
    }
}
