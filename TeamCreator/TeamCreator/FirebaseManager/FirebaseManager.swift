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
        db.collection("players").document(player.id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
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

    

}
