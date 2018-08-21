//
//  Room.swift
//  Draw
//
//  Created by Eduardo Fornari on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

struct Room {
    var identifier: String?
    var name: String
}

extension Room: CloudConvertible {
    static var typeName: String {
        return "Room"
    }

    //MARK: - Init

    init?(_ fbObject: [String : Any]) {
        guard let identifier = fbObject["identifier"] as? String,
            let name = fbObject["name"] as? String else { return nil }
        
        self.identifier = identifier
        self.name = name
    }

    func intoFBObject() -> [String : Any] {
        var fbObject = [String: Any]()

        fbObject["identifier"] = identifier
        fbObject["name"] = name

        return fbObject
    }
}
