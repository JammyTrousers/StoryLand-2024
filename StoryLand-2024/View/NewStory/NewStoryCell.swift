//
//  NewStoryCell.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct NewStoryCell: View {
    var body: some View {
        ZStack {
            Image(systemName: "plus")
                .foregroundStyle(Color.accentColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    NewStoryCell().background(.white)
}
