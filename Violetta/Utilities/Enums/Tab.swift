//
//  Tab.swift
//  Violetta
//
//  Created by Kevin Waltz on 24.09.24.
//

import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    case discover, favorites
    
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .discover: "Entdecken"
        case .favorites: "Favoriten"
        }
    }
    
    var icon: String {
        switch self {
        case .discover: "paintpalette"
        case .favorites: "heart"
        }
    }
    
    var view: some View {
        Group {
            switch self {
            case .discover: DiscoverView()
            case .favorites: FavoritesView()
            }
        }
    }
    
}
