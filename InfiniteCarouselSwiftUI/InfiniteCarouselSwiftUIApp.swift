//
//  InfiniteCarouselSwiftUIApp.swift
//  InfiniteCarouselSwiftUI
//
//  Created by Ruslan Magomedov on 04.01.2024.
//

import SwiftUI

@main
struct InfiniteCarouselSwiftUIApp: App {
    let items = [
        ItemAds(id: 0, color: .blue),
        ItemAds(id: 1, color: .gray),
        ItemAds(id: 2, color: .orange),
        ItemAds(id: 3, color: .red),
        ItemAds(id: 4, color: .yellow),
        ItemAds(id: 5, color: .pink),
    ]
    
    var body: some Scene {
        WindowGroup {
            InfinityScrollTabView(items: items) { item in
                Element(color: item.color, id: item.id)
            }
        }
    }
}
