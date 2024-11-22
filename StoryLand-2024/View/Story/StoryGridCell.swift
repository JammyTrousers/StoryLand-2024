//
//  StoryGridCell.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct StoryGridCell: View {

    @State var story: Story

    let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .gray, location: 0),
                .init(color: .clear, location: 0.4)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(story.backgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            GIFViewRepresentable(gifName: $story.coverImage)
        }
        .overlay {
            ZStack(alignment: .bottom) {
                Image("Background")
                    .resizable()
                    .blur(radius: 20) /// blur the image
                    .padding(-20) /// expand the blur a bit to cover the edges
                    .clipped() /// prevent blur overflow
                    .mask(gradient) /// mask the blurred image using the gradient's alpha values
                
                gradient /// also add the gradient as an overlay (this time, the purple will show up)
                
                HStack {
                    Text(story.name)
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.white)
                        .padding(.all, 40)
                }
            }
        }
        .frame(width: 550, height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding()
    }
}

#Preview {
    StoryGridCell(story: Story.defaultStory(title: .threelittlepigs))
}
