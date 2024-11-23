//
//  ShopCell.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct ShopCell: View {
    var shop: Shop
    
    var body: some View {
        HStack {
            VStack {
                Image(shop.itemName)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 200, height: 200)
                
                Text(shop.itemName)
            }
            .frame(maxWidth: .infinity)
            
            Button {
                DataManager.shared.purchaseItem(item: shop)
            } label: {
                HStack {
                    Text("\(shop.price)")

                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.yellow)
                }
            }
            .buttonStyle(.filled)

        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding()
    }
}


