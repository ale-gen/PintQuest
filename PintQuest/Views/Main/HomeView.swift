//
//  HomeView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 06/04/2023.
//

import SwiftUI

struct HomeView: View {
    
    private enum Constants {
        static let spacing: CGFloat = 15.0
        static let yOffset: CGFloat = 2.0
    }
    
    @Namespace var animation
    @State private var selectedTab: MenuTab = .browse
    @State private var showDetailView: Bool = false
    @State private var selectedBeer: Beer?
    @State private var searchName: String = String.empty
    private var apiViewModel = APIBeersCollectionViewModel(client: Clients.punkApiClient)
    private var memoryViewModel = FavBeersCollectionViewModel(memoryClient: Clients.coreDataClient, apiClient: Clients.punkApiClient)
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: Constants.spacing) {
                    ForEach(MenuTab.allCases, id: \.self) { tab in
                        Button {
                            withAnimation {
                                selectedTab = tab
                            }
                        } label: {
                            Text(tab.name)
                                .foregroundColor(selectedTab == tab ? .black : .gray)
                                .font(selectedTab == tab ? .title3 : .callout)
                                .fontWeight(selectedTab == tab ? .bold : .semibold)
                                .padding(.leading, selectedTab == tab ? .zero : Constants.spacing)
                                .offset(y: selectedTab == tab ? .zero : Constants.yOffset)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Constants.spacing)
                
                beerCollectionView
            }
            .overlay {
                if let selectedBeer, showDetailView {
                    BeerDetailView(animation: animation,
                                   beer: selectedBeer,
                                   viewModel: memoryViewModel,
                                   show: $showDetailView)
                    .transition(.identity)
                    .navigationTitle(String.empty)
                    .toolbar(.hidden, for: .navigationBar)
                }
            }
            .searchable(text: $searchName, prompt: Localizable.beerSearchBarPrompt.value)
            .navigationTitle(Localizable.homeNavigationBarTitle.value)
            .transition(.opacity)
            .onChange(of: searchName) { newValue in
                apiViewModel.resetPagination()
                guard newValue.isEmpty else {
                    memoryViewModel.getBeersByName(newValue)
                    apiViewModel.getBeersByName(newValue)
                    return
                }
                memoryViewModel.getBeers()
                apiViewModel.getBeers()
            }
        }
    }
    
    private var beerCollectionView: some View {
        switch selectedTab {
        case .browse:
            return AnyView(APIBeersCollectionView(animation: animation, viewModel: apiViewModel, showDetailView: $showDetailView, selectedBeer: $selectedBeer))
        case .fav:
            return AnyView(FavBeersCollectionView(animation: animation, viewModel: memoryViewModel, showDetailView: $showDetailView, selectedBeer: $selectedBeer))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
