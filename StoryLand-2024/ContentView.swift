//
//  ContentView.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navigation = TodayNavigation()
    
    var body: some View {
        HomeView()
            .environmentObject(navigation)
            .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
