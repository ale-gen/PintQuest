//
//  CoreDataClient.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 06/04/2023.
//

import CoreData
import Foundation

class CoreDataClient: Client {
    
    typealias ClientType = Int64
    
    func getData(_ parameters: Any...) -> [Int64] {
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
    
    @discardableResult
    func saveData(_ item: Int64) -> Bool {
        let context = PersistenceController.shared.container.viewContext
        let newItem = Item(context: context)
        newItem.id = item
        do {
            try context.save()
            return true
        } catch {
            print("Error during saving beer with id: \(item). Description: \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteData(_ item: Int64) -> Bool {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", item)
        do {
            guard let itemToDelete = try context.fetch(request).first else { return false }
            context.delete(itemToDelete)
            try context.save()
            return true
        } catch {
            print("Error during deleting beer with id: \(item). Description: \(error.localizedDescription)")
            return false
        }
    }
    
}
