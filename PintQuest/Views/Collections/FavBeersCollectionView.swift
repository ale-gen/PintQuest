//
//  FavBeersCollectionView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 07/04/2023.
//

import SwiftUI

struct FavBeersCollectionView: View {
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 15.0
        static let verticalPadding: CGFloat = 20.0
        enum Animation {
            static let response: CGFloat = 0.9
            static let dampingFraction: CGFloat = 0.9
            static let blendDuration: CGFloat = 0.1
        }
    }
    
    let animation: Namespace.ID
    @ObservedObject var viewModel: FavBeersCollectionViewModel
    @Binding var showDetailView: Bool
    @Binding var selectedBeer: Beer?
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.beers) { beer in
                    BeerRowView(beer: beer,
                                animation: animation,
                                shouldHideImage: showDetailView &&
                                selectedBeer?.id == beer.id)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: Constants.Animation.response, dampingFraction: Constants.Animation.dampingFraction, blendDuration: Constants.Animation.blendDuration)) {
                            selectedBeer = beer
                            showDetailView = true
                        }
                    }
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.verticalPadding)
        }
        .onAppear {
            viewModel.getBeers()
        }
    }
}

struct FavBeersCollectionView_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        FavBeersCollectionView(animation: animation, viewModel: FavBeersCollectionViewModel(memoryClient: Clients.coreDataClient, apiClient: Clients.punkApiClient), showDetailView: .constant(false), selectedBeer: .constant(nil))
    }
}
