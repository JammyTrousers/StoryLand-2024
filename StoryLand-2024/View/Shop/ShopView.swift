//
//  ShopView.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct ShopView: View {
    var shops: [Shop]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(shops) { shop in
                ShopCell(shop: shop)
            }
        }
    }
}
