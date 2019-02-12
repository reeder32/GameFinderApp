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

extension Game {
    // from vapor docs -- Imagine the parent relation as Parent<Child, Parent> or Parent<From, To>. Here we are relating from the pet type to the parent type.
    var gameLocation: Parent<Game, GameLocation> {
        return parent(\.gameLocationID)
    }
}
