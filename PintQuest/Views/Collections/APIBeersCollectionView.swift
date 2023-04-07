//
//  BeersCollectionView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import SwiftUI

struct APIBeersCollectionView: View {
    
    @ObservedObject var viewModel: APIBeersCollectionViewModel
    @Binding var showDetailView: Bool
    @Binding var selectedBeer: Beer?
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.beers) { beer in
                    BeerRowView(beer: beer,
                                animation: animation,
                                shouldHideImage: showDetailView &&
                                selectedBeer?.id == beer.id)
                    .onAppear {
                        viewModel.loadMoreContent(beer)
                    }
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
            viewModel.getBeers()
        }
    }
}

struct APIBeersCollectionView_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        APIBeersCollectionView(viewModel: APIBeersCollectionViewModel(client: PunkAPIClient()), showDetailView: .constant(false), selectedBeer: .constant(nil), animation: animation)
    }
}
