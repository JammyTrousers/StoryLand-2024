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
                
                Text(shop.itemName)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Text("\(shop.price)")

                Image(systemName: "star.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.yellow)
            }
            .frame(maxWidth: .infinity)

        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding()
    }
}


