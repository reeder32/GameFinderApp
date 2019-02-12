import Vapor
import FluentPostgreSQL
// This is Acronym in the tutorial
final class GameLocation: Codable {
    var id: Int?
    var name: String
    var lat: Double
    var long: Double
    var gameID: Game.ID

    init(name: String, lat: Double, long: Double, gameID: Game.ID) {
        self.name = name
        self.lat = lat
        self.long = long
        self.gameID = gameID
    }

}

extension GameLocation: PostgreSQLModel {}

extension GameLocation: Content {}
extension GameLocation: Parameter {}

extension GameLocation: Migration {
    static func prepare(
        on connection: PostgreSQLConnection
        ) -> Future<Void> {
        return Database.create(self, on: connection)
        { builder in
            try addProperties(to: builder)

            builder.reference(from: \.gameID, to: \Game.id)
        }
    }
}

extension GameLocation {
    var game: Parent<GameLocation, Game> {
        return parent(\.gameID)
    }
}
