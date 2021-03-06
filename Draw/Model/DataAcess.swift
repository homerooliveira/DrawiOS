//
//  DataBaseAcess.swift
//  Draw
//
//  Created by Homero Oliveira on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DataAcess {

    static let shared = DataAcess()

    let database = Database.database().reference()

    private init() {}

    deinit {
        database.removeAllObservers()
    }

    func removeAllObservers() {
        database.removeAllObservers()
    }

    // MARK: SAVE

    public func save(with room: Room, completion: @escaping (Error?) -> Void) {
        DataManager.shared.save(data: room, typeName: Room.typeName, completion: completion)
    }

    // MARK : Fetch

    public func fetchRoomsObservable(completion: @escaping ([Room]?) -> Void) {
        DataManager.shared.fetchObservable(eventType: DataEventType.value, typeName: Room.typeName, completion: completion)
    }

    public func fetchRoom(with name: String, completion: @escaping ([Room]?) -> Void) {
        let databaseReference: DatabaseReference = Database.database().reference()
        let query = databaseReference.child(Room.typeName).queryOrdered(byChild:
            "name").queryEqual(toValue: name)
        DataManager.shared.query(query: query, completion: completion)
    }

    // MARK : Delete

    public func deleteRoom(with roomID: String, completion: @escaping (Error?) -> Void) {
        DataManager.shared.delete(for: Room.typeName, with: roomID, completion: completion)
    }

}
