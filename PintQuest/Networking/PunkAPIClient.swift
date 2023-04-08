//
//  PunkAPIClient.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import Foundation

enum PunkAPIError: Error {
    case invalidParameters
    case invalidURL
    case invalidResponse
}

class PunkAPIClient: Client {
    
    typealias ClientType = Beer
    
    private let endpointType: ClientEndpoint
    
    init() {
        endpointType = .punkApi
    }
    
    func getData(_ parameters: Any...) async throws -> [Beer] {
        guard let page = parameters.first else {
            throw PunkAPIError.invalidParameters
        }
        guard let url = URL(string: "\(endpointType.baseUrl)beers?page=\(page)") else {
            throw PunkAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw PunkAPIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let beers = try decoder.decode([Beer].self, from: data)
        
        return beers
    }
    
    func getDataByIds(_ ids: [Int64]) async throws -> [Beer] {
        guard !ids.isEmpty else { return [] }
        var queryString = "?ids="
        for (index, id) in ids.enumerated() {
            queryString += "\(id)"
            if index != ids.count - 1 {
                queryString += "%7C"
            }
        }
        guard let url = URL(string: "\(endpointType.baseUrl)beers\(queryString)") else {
            throw PunkAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw PunkAPIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let beers = try decoder.decode([Beer].self, from: data)
        
        return beers
    }
    
    func getDataByName(_ name: String, _ page: Int) async throws -> [Beer] {
        let queryString = "?page=\(page)&beer_name=\(name.replacingOccurrences(of: " ", with: "_"))"
        guard let url = URL(string: "\(endpointType.baseUrl)beers\(queryString)") else {
            throw PunkAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw PunkAPIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let beers = try decoder.decode([Beer].self, from: data)
        
        return beers
    }
    
    func saveData(_ item: Beer) -> Bool { return false }
    func deleteData(_ item: Beer) -> Bool { return false }
}
