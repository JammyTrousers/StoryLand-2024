//
//  HomeView.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State var characterImage: String = "普通皮膚"
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    
    var buttons: some View {
        VStack(spacing: 40) {
            NavigationLink(destination: StorySelectionView(stories: categories.first!.stories)) {
                Label("Story Telling", systemImage: "ellipsis.message.fill")
            }
            
            
            Button {
                columnVisibility = .all
            } label: {
                Label("Shop", systemImage: "storefront.fill")
            }
            
        }
        .buttonStyle(.menu)
        .padding()
        .fixedSize()
        .onAppear {
            print("Haha: \(categories.first!.stories)")
        }
    }
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            VStack {
                ShopView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        columnVisibility = .detailOnly
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Text("2024")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.yellow)
                    }
                    .padding(.all, 10)
                    .background(Color.seaBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
            }
        } detail: {
            NavigationStack {
                UserScene(characterImage: $characterImage)
                    .ignoresSafeArea()
                    .navigationTitle("My Home")
                    .overlay(alignment: .trailing) {
                        buttons
                            .offset(x: columnVisibility == .detailOnly ? 0 : UIScreen.main.bounds.width)
                            .opacity(columnVisibility == .detailOnly ? 1 : 0)
                            .animation(.easeOut(duration: 0.3), value: columnVisibility == .detailOnly)
                    }
            }
        }
    }
}

#Preview {
    HomeView()
}
