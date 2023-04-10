//
//  BeersCollectionView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import SwiftUI

struct APIBeersCollectionView: View {
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 15.0
        static let verticalPadding: CGFloat = 20.0
        enum Animation {
            static let response: CGFloat = 0.9
            static let dampingFraction: CGFloat = 0.9
            static let blendDuration: CGFloat = 0.1
        }
        enum EmptyState {
            static let yOffset: CGFloat = -50.0
            static let image: Image = Image("Beers")
        }
    }
    
    let animation: Namespace.ID
    @ObservedObject var viewModel: APIBeersCollectionViewModel
    @Binding var showDetailView: Bool
    @Binding var selectedBeer: Beer?
    
    var body: some View {
        Group {
            if viewModel.loaded && viewModel.beers.isEmpty {
                EmptyStateView(model: EmptyState(image: Constants.EmptyState.image, title: Localizable.emptyStateTitleBrowseBeersCollection.value, buttonTitle: Localizable.emptyStateButtonTitleBrowseBeersCollection.value))
                    .offset(y: Constants.EmptyState.yOffset)
            } else {
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
            }
        }
        .onAppear {
            viewModel.getBeers()
        }
    }
}

struct APIBeersCollectionView_Previews: PreviewProvider {
    @Namespace static var animation
    
    static var previews: some View {
        APIBeersCollectionView(animation: animation, viewModel: APIBeersCollectionViewModel(client: PunkAPIClient()), showDetailView: .constant(false), selectedBeer: .constant(nil))
    }
}
