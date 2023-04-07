//
//  FavBeersCollectionView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 07/04/2023.
//

import SwiftUI

struct FavBeersCollectionView: View {
    
    @ObservedObject var viewModel: FavBeersCollectionViewModel
    @Binding var showDetailView: Bool
    @Binding var selectedBeer: Beer?
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.beers) { beer in
                    BeerRowView(beer: beer,
                                animation: animation,
                                shouldHideImage: showDetailView &&
                                selectedBeer?.id == beer.id)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.9, dampingFraction: 0.9, blendDuration: 0.1)) {
                            selectedBeer = beer
                            showDetailView = true
                        }
                    }
                }
            }
            .padding(.horizontal, 15.0)
            .padding(.vertical, 20.0)
        }
        .onAppear {
            viewModel.fetchBeers()
        }
    }
}

struct FavBeersCollectionView_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        FavBeersCollectionView(viewModel: FavBeersCollectionViewModel(memoryClient: Clients.coreDataClient, apiClient: Clients.punkApiClient), showDetailView: .constant(false), selectedBeer: .constant(nil), animation: animation)
    }
}
