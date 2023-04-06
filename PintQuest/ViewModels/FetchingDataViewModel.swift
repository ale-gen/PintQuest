//
//  FetchingDataViewModel.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import Foundation

protocol FetchingDataViewModel {
    
    func fetchBeers() -> Task<[Beer], any Error>
}
