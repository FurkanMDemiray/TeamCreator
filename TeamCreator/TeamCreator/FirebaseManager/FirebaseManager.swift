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
    func deletePlayer(player: Player, completion: @escaping (Result<Void, Error>) -> Void)
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
            try db.collection(Constant.players).addDocument(from: player) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func fetchPlayers(completion: @escaping (Result<[Player], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection(Constant.players).getDocuments { (snapshot, error) in
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

    func deletePlayer(player: Player, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection(Constant.players)

        collectionRef.whereField(Constant.id, isEqualTo: player.id).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("\(Constant.errorQuery) \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print(Constant.noPlayerFound)
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: Constant.noPlayerFound])))
                return
            }

            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        print("\(Constant.errorDelete) \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("\(Constant.succesDelete) \(player.id)")
                        completion(.success(()))
                    }
                }
            }
        }
    }

    func updatePlayer(player: Player, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection(Constant.players)

        // Query the document with the specific player ID
        collectionRef.whereField(Constant.id, isEqualTo: player.id).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("\(Constant.errorQuery) \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let document = querySnapshot?.documents.first else {
                print(Constant.noPlayerFound)
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: Constant.noPlayerFound])))
                return
            }

            // Update the document with the new player data
            do {
                try document.reference.setData(from: player, merge: true) // merge: true will keep existing fields
                print("\(Constant.successUpdate) \(player.id)")
                completion(.success(()))
            } catch {
                print("\(Constant.errorUpdate) \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

private extension FirebaseManager {
    enum Constant {
        static let players = "players"
        static let id = "id"
        static let errorQuery = "Error querying player:"
        static let errorUpdate = "Error updating player:"
        static let errorDelete = "Error deleting player:"
        static let noPlayerFound = "No matching player found"
        static let successUpdate = "Successfully updated player with id"
        static let succesDelete = "Successfully deleted player with id "
    }
}
