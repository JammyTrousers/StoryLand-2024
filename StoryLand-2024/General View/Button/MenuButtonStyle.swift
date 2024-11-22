//
//  MenuButtonStyle.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct MenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .font(.title)
            .bold()
            .padding(.all, 30)
            .background(.white)
            .foregroundStyle(Color.seaBlue)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Add a slight scale effect when pressed
    }
}

extension ButtonStyle where Self == MenuButtonStyle {
    static var menu: Self {
        return .init()
    }
}

#Preview {
    Button("Hello") {
        
    }
    .buttonStyle(.menu)
}

