//
//  BeersCollectionView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import SwiftUI

struct BeersCollectionView: View {
    
    @ObservedObject var viewModel: BeersCollectionViewModel
    @Namespace var animation
    @State private var showDetailView: Bool = false
    @State private var selectedBeer: Beer?
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 15.0) {
                    ForEach(MenuTab.allCases, id: \.self) { tab in
                        Button {
                            withAnimation {
                                viewModel.selectedTab = tab
                            }
                        } label: {
                            Text(tab.name)
                                .foregroundColor(viewModel.selectedTab == tab ? .black : .gray)
                                .font(viewModel.selectedTab == tab ? .title3 : .callout)
                                .fontWeight(viewModel.selectedTab == tab ? .bold : .semibold)
                                .padding(.leading, viewModel.selectedTab == tab ? 0.0 : 15.0)
                                .offset(y: viewModel.selectedTab == tab ? 0.0 : 2.0)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15.0)
                
                ScrollView {
                    LazyVStack {
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
                        .searchable(text: $searchText)
                    }
                    .padding(.horizontal, 15.0)
                    .padding(.vertical, 20.0)
                }
            }
            .overlay {
                if let selectedBeer, showDetailView {
                    BeerDetailView(show: $showDetailView,
                                   beer: selectedBeer,
                                   animation: animation,
                                   viewModel: FavBeersCollectionViewModel())
                        .transition(.identity)
                }
            }
            .navigationTitle("Beers")
        }
        .onAppear {
            Task {
                await viewModel.fetchBeers()
            }
        }
        .onChange(of: viewModel.selectedTab) { newValue in
            Task {
                await viewModel.fetchBeers()
            }
        }
    }
}

struct BeersCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        BeersCollectionView(viewModel: BeersCollectionViewModel())
    }
}
