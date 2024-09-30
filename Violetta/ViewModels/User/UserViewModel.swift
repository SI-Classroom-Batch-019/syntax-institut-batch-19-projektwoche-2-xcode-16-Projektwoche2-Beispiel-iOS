//
//  UserViewModel.swift
//  Violetta
//
//  Created by Kevin Waltz on 26.09.24.
//

import Foundation
import FirebaseAuth

class UserViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let firebaseManager = FirebaseManager.shared
    
    @Published var isAuthenticating = false
    @Published var user: FireUser?
    
    var userIsLoggedIn: Bool {
        FirebaseManager.shared.auth.currentUser != nil
    }
    
    
    
    // MARK: - Body
    
    init() {
        checkAuth()
    }
    
    
    
    // MARK: - Functions
    
    /// Überprüfen, ob aktuell ein User angemeldet ist. Falls ja, wird der User gesetzt.
    /// Sollte bei jedem App-Start ausgeführt werden.
    private func checkAuth() {
        guard let currentUser = firebaseManager.auth.currentUser else {
            print("Not logged in")
            return
        }
        
        self.fetchUser(with: currentUser.uid)
    }
    
    /// Zum Login nehmen wir E-Mail und Passwort. Falls kein Error entsteht, setzen wir den neu angemeldeten User.
    func loginAnonymously() {
        isAuthenticating = true
        
        firebaseManager.auth.signInAnonymously { authResult, error in
            if let error {
                print("SignIn failed:", error.localizedDescription)
                return
            }
            
            guard let authResult else { return }
            print("User is authenticated with id '\(authResult.user.uid)'")
            
            self.createUser(with: authResult.user.uid)
            self.isAuthenticating = false
        }
    }
    
}



// MARK: User

extension UserViewModel {
    
    /// Erstellen eines User-Dokuments im Firestore.
    /// Als 'registeredAt' setzen wir das Datum für den Moment, in dem die Registrierung statt findet.
    /// In der Collection 'users' wird unter der jeweiligen ID des Users ein Dokument erstellt. Dazu kann das Objekt übergeben werden.
    private func createUser(with id: String) {
        let user = FireUser(id: id, registeredOn: Date())
        
        do {
            try firebaseManager.database.collection("users").document(id).setData(from: user)
            self.fetchUser(with: id)
        } catch let error {
            print("Fehler beim Speichern des Users: \(error)")
        }
    }
    
    /// Der User wird mit der ID geladen, die der auf dem Gerät angemeldete User hat.
    /// Das Dokument, das geladen wird, wird zu einem 'FireUser' und 'user' wird angeschließend gesetzt.
    /// Hinweis: Hier gibt es noch keinen Listener, d.h. es findet kein Echtzeit-Sync statt, das kommt in der nächsten Vorlesung (Teil 4).
    private func fetchUser(with id: String) {
        firebaseManager.database.collection("users").document(id).addSnapshotListener { document, error in
            if let error {
                print(error)
                return
            }
            
            guard let document else {
                print("Fehler beim Laden des Users")
                return
            }
            
            do {
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                print("Dokument ist kein User", error)
            }
        }
    }
    
}
