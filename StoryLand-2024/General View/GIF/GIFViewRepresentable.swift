//
//  GIFViewRepresentable.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct GIFViewRepresentable: UIViewRepresentable {
    
    @Binding var gifName: String

    func makeUIView(context: Context) -> GIFView {
        GIFView(gifName: gifName)
    }
    
    func updateUIView(_ uiView: GIFView, context: UIViewRepresentableContext<GIFViewRepresentable>) {
        uiView.loadGIF(gifName: gifName)
    }
    
}
