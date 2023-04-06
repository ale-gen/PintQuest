//
//  APIClient.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import Foundation

protocol APIClient {
    
    func fetchBeers() async throws -> [Beer]
    func fetchBeersByIds(_ ids: [Int64]) async throws -> [Beer]
}
