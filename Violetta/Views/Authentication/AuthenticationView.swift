//
//  AuthenticationView.swift
//  Violetta
//
//  Created by Kevin Waltz on 26.09.24.
//

import SwiftUI

struct AuthenticationView: View {
    
    // MARK: - Properties
    
    @ObservedObject var userViewModel: UserViewModel
    
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MeshGradient(width: 2, height: 2,
                points: [
                    .init(x: 0, y: 0), .init(x: 1, y: 0),
                    .init(x: 0, y: 1), .init(x: 1, y: 1),
                ], colors: [.red, .orange, .pink, .purple, .blue]
            )
            .ignoresSafeArea()
            
            PlaceholderView(icon: "paintpalette.fill", title: "Willkommen bei", subtitle: "Violetta!", foregroundStyle: .white)
            
            CircleButton(foregroundColor: .black, backgroundColor: .white, icon: "arrow.right") {
                userViewModel.loginAnonymously()
            }
            .padding(.bottom, Values.majorPadding)
        }
        .statusBarHidden()
    }
    
}

#Preview {
    AuthenticationView(userViewModel: UserViewModel())
}
