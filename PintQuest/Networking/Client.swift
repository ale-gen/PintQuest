//
//  Client.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 06/04/2023.
//

import Foundation

struct Clients {
    static let punkApiClient: PunkAPIClient = PunkAPIClient()
    static let coreDataClient: CoreDataClient = CoreDataClient()
}

protocol Client {
    
    associatedtype ClientType
    
    func getData(_ parameters: Any...) async throws -> [ClientType]
    func saveData(_ item: ClientType) -> Bool
    func deleteData(_ item: ClientType) -> Bool
}

enum ClientEndpoint {
    case punkApi
    
    var baseUrl: String {
        switch self {
        case .punkApi:
            return "https://api.punkapi.com/v2/"
        }
    }
}
