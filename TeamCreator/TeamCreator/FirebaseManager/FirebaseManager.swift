//
//  FirebaseManager.swift
//  TeamCreator
//
//  Created by Melik Demiray on 3.08.2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

protocol FirebaseManagerProtocol {
    func addPlayer(player: Player, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchPlayers(completion: @escaping (Result<[Player], Error>) -> Void)
    // func addMatch(match: Match, completion: @escaping (Result<Void, Error>) -> Void)
    // func fetchMatches(completion: @escaping (Result<[Match], Error>) -> Void)
    func deletePlayer(player: Player, completion: @escaping (Result<Void, Error>) -> Void)
    // func deleteMatch(match: Match, completion: @escaping (Result<Void, Error>) -> Void)
    func updatePlayer(player: Player, completion: @escaping (Result<Void, Error>) -> Void)
}

final class FirebaseManager: FirebaseManagerProtocol {

    static let shared = FirebaseManager()

    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    func addPlayer(player: Player, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        do {
            let _ = try db.collection("players").addDocument(from: player)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    func fetchPlayers(completion: @escaping (Result<[Player], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("players").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            if let snapshot = snapshot {
                let players = snapshot.documents.compactMap { (queryDocumentSnapshot) -> Player? in
                    return try? queryDocumentSnapshot.data(as: Player.self)
                }
                completion(.success(players))
            }
        }
    }

    /*func addMatch(match: Match, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        do {
            let _ = try db.collection("matches").addDocument(from: match)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    func fetchMatches(completion: @escaping (Result<[Match], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("matches").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            }
            if let snapshot = snapshot {
                let matches = snapshot.documents.compactMap { (queryDocumentSnapshot) -> Match? in
                    return try? queryDocumentSnapshot.data(as: Match.self)
                }
                completion(.success(matches))
            }
        }
    }*/

    func deletePlayer(player: Player, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("players")

        // player.id alanına göre belgeyi sorgula
        collectionRef.whereField("id", isEqualTo: player.id).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying player: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No matching player found")
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No matching player found"])))
                return
            }

            // Belgeyi sil
            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting player: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("Successfully deleted player with id \(player.id)")
                        completion(.success(()))
                    }
                }
            }
        }
    }

    /* func deleteMatch(match: Match, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("matches").document(match.id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }*/

    func updatePlayer(player: Player, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("players")

        // Query the document with the specific player ID
        collectionRef.whereField("id", isEqualTo: player.id).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying player: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let document = querySnapshot?.documents.first else {
                print("No matching player found")
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "No matching player found"])))
                return
            }

            // Update the document with the new player data
            do {
                try document.reference.setData(from: player, merge: true)  // merge: true will keep existing fields
                print("Successfully updated player with id \(player.id)")
                completion(.success(()))
            } catch {
                print("Error updating player: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }


}
