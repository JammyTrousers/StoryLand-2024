//
//  FilledButtonStyle.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.seaBlue) // Customize the fill color here
            .foregroundColor(.white) // Customize the text color here
            .cornerRadius(24) // Adjust the corner radius as needed
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Add a slight scale effect when pressed
    }
}

extension ButtonStyle where Self == FilledButtonStyle {
    static var filled: Self {
        return .init()
    }
}

#Preview {
    Button("Hello") {
        
    }
    .buttonStyle(.filled)
}


