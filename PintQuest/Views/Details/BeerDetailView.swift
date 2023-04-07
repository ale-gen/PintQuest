//
//  BeerDetailView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import SwiftUI
import CachedAsyncImage

struct BeerDetailView: View {
    
    @Binding var show: Bool
    var beer: Beer
    let animation: Namespace.ID
    var viewModel: FavBeersCollectionViewModel
    @State private var isFavourite: Bool = false
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .fill(Color.beige)
                    .offset(x: -10.0)
                if show {
                    CachedAsyncImage(url: URL(string: beer.imageUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: .infinity)
                            .padding(80.0)
                            .shadow(radius: 30.0)
                            .matchedGeometryEffect(id: beer.id, in: animation)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .offset(x: -UIScreen.main.bounds.midX + 20.0)
            
            VStack {
                HStack {
                    Button {
                        withAnimation(.easeIn(duration: 0.35)) {
                            show.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Button {
                        if !isFavourite {
                            addFavBeer(id: beer.id)
                        } else {
                            deleteFavBeer(id: beer.id)
                        }
                        isFavourite.toggle()
                    } label: {
                        Image(systemName: isFavourite ? "heart.fill" : "heart")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 25.0)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Spacer(minLength: UIScreen.main.bounds.midX / 2)
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text(beer.tagline.replacingOccurrences(of: ".", with: ""))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .opacity(0.8)
                        Text(beer.name)
                            .font(.title)
                            .bold()
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 10.0) {
                                Group {
                                    Text("Description: ")
                                        .fontWeight(.semibold)
                                        .underline()
                                    Text(beer.description)
                                        .foregroundColor(.black.opacity(0.8))
                                }
                                .padding(.leading, 35.0)
                                .padding(.trailing, 10.0)
                                
                                Group {
                                    Text("Parameters: ")
                                        .fontWeight(.semibold)
                                        .underline()
                                    StatLevelView(statKind: .abv, value: beer.abv)
                                    StatLevelView(statKind: .ibu, value: beer.ibu)
                                    StatLevelView(statKind: .ebc, value: beer.ebc)
                                }
                                .padding(.leading, 35.0)
                                
                                if let brewersTips = beer.brewersTips {
                                    Group {
                                        Text("Brewer tips: ")
                                            .fontWeight(.semibold)
                                            .underline()
                                        Text(brewersTips)
                                            .foregroundColor(.black.opacity(0.8))
                                    }
                                    .padding(.leading, 35.0)
                                }
                            }
                        }
                        .padding(.top, 20.0)
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .background(
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
        )
        .onAppear {
            isFavourite = isMarkedAsFav(id: beer.id)
        }
    }
    
    private func addFavBeer(id: Int) {
        viewModel.saveFavBeer(with: Int64(id))
    }
    
    private func deleteFavBeer(id: Int) {
        viewModel.deleteFavBeer(with: Int64(id))
    }
    
    private func isMarkedAsFav(id: Int) -> Bool {
        return viewModel.fetchFavBeer(with: Int64(id))
    }
    
}

struct BeerDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        BeerDetailView(show: .constant(true),
                       beer: Beer.mock,
                       animation: namespace,
                       viewModel: FavBeersCollectionViewModel(memoryClient: CoreDataClient(),
                                                              apiClient: PunkAPIClient()))
    }
}
