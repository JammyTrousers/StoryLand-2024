//
//  UserScene.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct UserScene: View {
    @Binding var characterImage: String
    
    @ViewBuilder
    var character: some View {
        Image(characterImage)
                .scaledToFit()
    }
    
    var body: some View {
        GeometryReader { gp in
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        character
                    }
                }
                .frame(width: gp.size.width, height: gp.size.height * 0.9, alignment: .bottom)
                .background(Color.wall)
                
                VStack {
                    
                }
                .frame(width: gp.size.width, height: gp.size.height * 0.1)
                .background(Color.floor)
            }
        }
    }
}

#Preview {
    @State var characterImage: String = "普通皮膚"
    return UserScene(characterImage: $characterImage)
}
