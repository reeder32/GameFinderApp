import Foundation
import Vapor
import FluentPostgreSQL
// This is User in the tutorial
final class Game: Codable {
    var id: UUID?
    var date: Date
    var users: [User]?
    var gameLocationID: GameLocation.ID

    init(date: Date, gameLocationID: GameLocation.ID) {
        self.date = date
        self.gameLocationID = gameLocationID
    }
}

extension Game: PostgreSQLUUIDModel {}
extension Game: Content {}
extension Game: Parameter {}
extension Game: Migration {}

