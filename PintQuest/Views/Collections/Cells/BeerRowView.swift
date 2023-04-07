//
//  BeerRowView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 01/04/2023.
//

import SwiftUI
import CachedAsyncImage

struct BeerRowView: View {
    
    let beer: Beer
    var animation: Namespace.ID
    var shouldHideImage: Bool
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            
            HStack(spacing: -10.0) {
                VStack(alignment: .leading, spacing: 5.0) {
                    HStack {
                        Text(beer.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                    }
                    
                    Text(beer.tagline)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        StatLevelView(statKind: .ibu, value: beer.ibu)
                        Spacer()
                        StatLevelView(statKind: .abv, value: beer.abv)
                        Spacer()
                    }
                    .padding(.top, 10.0)
                    
                    Spacer(minLength: 2.0)
                    
                    HStack {
                        HStack(spacing: 1.0) {
                            Text("Brewed from:")
                            Text(beer.firstBrewed)
                        }
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.trailing, 10.0)
                    }
                }
                .padding(20.0)
                .frame(width: 2 * size.width / 3, height: 0.8 * size.height, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8.0, x: 5, y: -5)
                        .shadow(color: .black.opacity(0.08), radius: 8.0, x: -5, y: 5)
                }
                
                ZStack {
                    if !shouldHideImage {
                        CachedAsyncImage(url: URL(string: beer.imageUrl ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width / 3, height: size.height * 0.8)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                                .matchedGeometryEffect(id: beer.id, in: animation)
                                .padding(2.0)
                                .background {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .fill(Color.beige)
                                        .shadow(radius: 10.0)
                                        .frame(width: size.width / 3, height: size.height)
                                }
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
        }
        .frame(minHeight: 220.0)
    }
}


struct BeerRowView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        BeerRowView(beer: Beer.mock,
                    animation: namespace,
                    shouldHideImage: false)
    }
}

