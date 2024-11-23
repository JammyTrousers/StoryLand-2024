//
//  UserScene.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct UserScene: View {
    @Binding var characterImage: String
    var purchased: [String]
    
    @ViewBuilder
    var character: some View {
        Image(characterImage)
                .scaledToFit()
    }
    
    var light: some View {
        Image("小燈")
                .scaledToFit()
    }
    
    var bed: some View {
        Image("床")
                .scaledToFit()
    }
    
    var body: some View {
        GeometryReader { gp in
            VStack(spacing: 0) {
                VStack(alignment: .center) {
                    ZStack(alignment: .bottom) {
                        character
                        
                        HStack(alignment: .bottom) {
                            light.opacity(purchased.contains("小燈") ? 1 : 0)
                            
                            Spacer()
                            
                            bed.opacity(purchased.contains("床") ? 1 : 0)
                            
                        }.padding(.horizontal, 10)
                    }
                }
                .frame(width: gp.size.width, height: gp.size.height * 0.9, alignment: .bottom)
                .background(Color.wall)
                
                VStack {
                    
                }
                .frame(width: gp.size.width, height: gp.size.height * 0.1)
                .background(Color.floor)
            }
            .onAppear {
                print("Purchased items:\(purchased)")
            }
        }
    }
}
