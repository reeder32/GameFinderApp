import Foundation
import Vapor
import FluentPostgreSQL
// This is User in the tutorial
final class Game: Codable {
    var id: UUID?
    var date: Date
    var users: [User]?

    init(date: Date) {
        self.date = date
    }
}

extension Game: PostgreSQLUUIDModel {}
extension Game: Content {}
extension Game: Parameter {}
extension Game: Migration {}

