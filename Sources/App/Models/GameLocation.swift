import Vapor
import FluentPostgreSQL

// This is Acronym in the tutorial
final class GameLocation: Codable {
    var id: Int?
    var name: String
    var lat: Double
    var long: Double


    init(name: String, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }

}

extension GameLocation: PostgreSQLModel {}
extension GameLocation: Content {}
extension GameLocation: Parameter {}
extension GameLocation: Migration {}

extension GameLocation {
    // From vapor docs -- "Imagine the children relation as Children<Parent, Child> or Children<From, To>. Here we are relating from the user type to the pet type."
    var games: Children<GameLocation, Game> {
        return children(\.gameLocationID)
    }
}

