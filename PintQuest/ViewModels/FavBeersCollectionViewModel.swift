//
//  FavBeersCollectionViewModel.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import Foundation
import CoreData

struct FavBeersCollectionViewModel: FetchingDataViewModel {
   
    func fetchBeerIds() -> [Int64] {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let items = try context.fetch(request)
            return items.map { $0.id }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return []
    }
    
    func fetchBeers() -> Task<[Beer], any Error> {
        let ids = fetchBeerIds()
        return APIBeersCollectionViewModel(apiClient: PunkAPIClient()).fetchBeersByIds(ids)
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
        let context = PersistenceController.shared.container.viewContext
        let newItem = Item(context: context)
        newItem.id = id
        do {
            try context.save()
        } catch {
            print("Error during saving beer with id: \(id). Description: \(error.localizedDescription)")
        }
    }
    
    func deleteFavBeer(with id: Int64) {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            guard let itemToDelete = try context.fetch(request).first else { return }
            context.delete(itemToDelete)
            try context.save()
        } catch {
            print("Error during deleting beer with id: \(id). Description: \(error.localizedDescription)")
        }
    }
}
