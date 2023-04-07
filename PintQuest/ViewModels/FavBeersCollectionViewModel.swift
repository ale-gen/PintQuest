//
//  FavBeersCollectionViewModel.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import Foundation
import CoreData

class FavBeersCollectionViewModel: ObservableObject {
    
    @Published var beers: [Beer] = []
    private let memoryClient: CoreDataClient
    private let apiClient: PunkAPIClient
    
    init(memoryClient: CoreDataClient, apiClient: PunkAPIClient) {
        self.memoryClient = memoryClient
        self.apiClient = apiClient
    }
    
    @MainActor
    func fetchBeers() {
        Task {
            let ids = memoryClient.getData()
            beers = try await apiClient.fetchBeersByIds(ids)
        }
    }
    
    func fetchFavBeer(with id: Int64) -> Bool {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let items = try context.fetch(request)
            guard !items.isEmpty else { return false }
            return true
        } catch {
            print("Error during fetching fav beer with id: \(id). Description: \(error.localizedDescription)")
        }
        return false
    }
    
    func saveFavBeer(with id: Int64) {
        memoryClient.saveData(id)
    }
    
    func deleteFavBeer(with id: Int64) {
        guard memoryClient.deleteData(id) else { return }
        beers = beers.filter { $0.id != id }
    }
    
}
