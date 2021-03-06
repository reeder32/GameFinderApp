//
//  User.swift
//  App
//
//  Created by Nick Reeder on 2/11/19.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class User: Codable {
    var id: UUID?
    var name: String
    var username: String

    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}

extension User: PostgreSQLUUIDModel {}
extension User: Content {}
extension User: Migration {}
extension User: Parameter {}

extension User {
    var gameLocations: Children <User, GameLocation> {
        return children(\.userID)
    }
}
