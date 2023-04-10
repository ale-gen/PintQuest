//
//  EmptyStateView.swift
//  PintQuest
//
//  Created by Aleksandra Generowicz on 10/04/2023.
//

import SwiftUI

struct EmptyStateView: View {
    
    private enum Constants {
        static let spacing: CGFloat = 5.0
        
        enum Image {
            static let height: CGFloat = 200.0
            static let width: CGFloat = height
            static let yOffset: CGFloat = 20.0
        }
        enum Title {
            static let color: Color = .darkBrown.opacity(0.7)
            static let font: Font = .headline
        }
        enum Button {
            static let color: Color = .darkBrown
            static let font: Font = .callout
        }
    }
    
    let model: EmptyState
    var didButtonTapped: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Constants.spacing) {
            Spacer()
            model.image
                .resizable()
                .scaledToFit()
                .frame(width: Constants.Image.width, height: Constants.Image.height)
                .offset(y: Constants.Image.yOffset)
            Text(model.title)
                .foregroundColor(Constants.Title.color)
                .font(Constants.Title.font)
            Button {
                didButtonTapped?()
            } label: {
                Text(model.buttonTitle)
                    .foregroundColor(Constants.Button.color)
                    .bold()
                    .font(Constants.Title.font)
            }
            Spacer()
        }
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(model: EmptyState(image: Image("Beers"), title: "No items", buttonTitle: "Create new item"))
    }
}
