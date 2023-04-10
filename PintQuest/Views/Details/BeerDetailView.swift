//
//  BeerDetailView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import SwiftUI
import CachedAsyncImage

struct BeerDetailView: View {
    
    private enum Constants {
        enum NavBar {
            static let font: Font = .title3
            static let fontWeight: Font.Weight = .semibold
            static let color: Color = .black
            static let horizontalPadding: CGFloat = 25.0
        }
        enum Tagline {
            static let font: Font = .subheadline
            static let fontWeight: Font.Weight = .semibold
            static let opacity: CGFloat = 0.8
        }
        enum Title {
            static let font: Font = .title
            static let fontWeight: Font.Weight = .semibold
        }
        enum ContentText {
            static let color: Color = .black.opacity(0.8)
        }
        enum Circle {
            static let color: Color = .beige
            static let additionalXOffset: CGFloat = -10.0
        }
        enum Image {
            static let padding: CGFloat = 80.0
            static let shadowRadius: CGFloat = 30.0
            static let xOffset: CGFloat = -UIScreen.main.bounds.midX + 20.0
        }
        enum Animation {
            static let duration: CGFloat = 0.35
        }
        enum Background {
            static let color: Color = .white
            static let leadingSpacing: CGFloat = UIScreen.main.bounds.midX / 2
        }
        static let spacing: CGFloat = 10.0
    }
    
    let animation: Namespace.ID
    let beer: Beer
    let viewModel: FavBeersCollectionViewModel
    @Binding var show: Bool
    @State private var isFavourite: Bool = false
    
    var body: some View {
        ZStack {
            beerImage
            
            VStack {
                navBar
                content
            }
        }
        .background(
            Rectangle()
                .fill(Constants.Background.color)
                .ignoresSafeArea()
        )
        .onAppear {
            isFavourite = isMarkedAsFav(id: beer.id)
        }
    }
    
    private var navBar: some View {
        HStack {
            Button {
                withAnimation(.easeIn(duration: Constants.Animation.duration)) {
                    show.toggle()
                }
            } label: {
                Icons.leftArrow.value
            }
            Spacer()
            favButton
        }
        .font(Constants.NavBar.font)
        .fontWeight(Constants.NavBar.fontWeight)
        .foregroundColor(Constants.NavBar.color)
        .padding(.horizontal, Constants.NavBar.horizontalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var favButton: some View {
        Button {
            if !isFavourite {
                addFavBeer(id: beer.id)
            } else {
                deleteFavBeer(id: beer.id)
            }
            isFavourite.toggle()
        } label: {
            Image(systemName: isFavourite ? Icons.heartFill.name : Icons.heart.name)
        }
    }
    
    private var beerImage: some View {
        ZStack {
            Circle()
                .fill(Constants.Circle.color)
                .offset(x: Constants.Circle.additionalXOffset)
            if show {
                CachedAsyncImage(url: URL(string: beer.imageUrl ?? .empty)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: .infinity)
                        .padding(Constants.Image.padding)
                        .shadow(radius: Constants.Image.shadowRadius)
                        .matchedGeometryEffect(id: beer.id, in: animation)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .offset(x: Constants.Image.xOffset)
    }
    
    private var content: some View {
        HStack {
            Spacer(minLength: Constants.Background.leadingSpacing)
            VStack(alignment: .leading, spacing: Constants.spacing) {
                Text(beer.tagline.replacingOccurrences(of: String.dot, with: String.empty))
                    .font(Constants.Tagline.font)
                    .fontWeight(Constants.Tagline.fontWeight)
                    .opacity(Constants.Tagline.opacity)
                Text(beer.name)
                    .font(Constants.Title.font)
                    .bold()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Constants.spacing) {
                        Group {
                            sectionTitle(Localizable.descriptionSectionTitleBeerDetailView.value)
                            Text(beer.description)
                                .foregroundColor(Constants.ContentText.color)
                        }
                        .padding(.leading, 35.0)
                        .padding(.trailing, 10.0)
                        
                        Group {
                            sectionTitle(Localizable.parametersSectionTitleBeerDetailView.value)
                            StatLevelView(statKind: .abv, value: beer.abv)
                            StatLevelView(statKind: .ibu, value: beer.ibu)
                            StatLevelView(statKind: .ebc, value: beer.ebc)
                        }
                        .padding(.leading, 35.0)
                        
                        if let brewersTips = beer.brewersTips {
                            Group {
                                sectionTitle(Localizable.brewerTipsSectionTitleBeerDetailView.value)
                                Text(brewersTips)
                                    .foregroundColor(Constants.ContentText.color)
                            }
                            .padding(.leading, 35.0)
                        }
                    }
                }
                .padding(.top, 20.0)
            }
            .padding([.top, .horizontal])
        }
    }
    
    private func sectionTitle(_ title: String) -> some View {
        return Text(title)
            .fontWeight(Constants.Title.fontWeight)
            .underline()
    }
    
    private func addFavBeer(id: Int) {
        viewModel.saveFavBeer(with: Int64(id))
    }
    
    private func deleteFavBeer(id: Int) {
        viewModel.deleteFavBeer(with: Int64(id))
    }
    
    private func isMarkedAsFav(id: Int) -> Bool {
        return viewModel.getFavBeer(with: Int64(id))
    }
}

struct BeerDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        BeerDetailView(animation: namespace,
                       beer: Beer.mock,
                       viewModel: FavBeersCollectionViewModel(memoryClient: CoreDataClient(),
                                                              apiClient: PunkAPIClient()),
                       show: .constant(true))
    }
}
