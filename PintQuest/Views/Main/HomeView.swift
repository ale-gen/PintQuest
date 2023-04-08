//
//  HomeView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 06/04/2023.
//

import SwiftUI

struct HomeView: View {
    
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
                HStack(spacing: 15.0) {
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
                                .padding(.leading, selectedTab == tab ? 0.0 : 15.0)
                                .offset(y: selectedTab == tab ? 0.0 : 2.0)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15.0)
                
                beerCollectionView            }
            .overlay {
                if let selectedBeer, showDetailView {
                    BeerDetailView(show: $showDetailView,
                                   beer: selectedBeer,
                                   animation: animation,
                                   viewModel: memoryViewModel)
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
            return AnyView(APIBeersCollectionView(viewModel: apiViewModel, showDetailView: $showDetailView, selectedBeer: $selectedBeer, animation: animation))
        case .fav:
            return AnyView(FavBeersCollectionView(viewModel: memoryViewModel, showDetailView: $showDetailView, selectedBeer: $selectedBeer, animation: animation))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
