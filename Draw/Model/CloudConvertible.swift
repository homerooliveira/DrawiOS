//
//  CloudConvertible.swift
//  Draw
//
//  Created by Eduardo Fornari on 08/11/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import CloudKit

protocol CloudConvertible: Equatable {

    static var typeName: String { get }

    var identifier: String? { get }

    func intoFBObject() -> [String: Any]

    init?(_ fbObject: [String: Any])

}

extension CloudConvertible {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
