import Vapor
import FluentPostgreSQL

// This is Acronym in the tutorial
final class GameLocation: Codable {
    var id: Int?
    var name: String
    var lat: Double
    var long: Double
    var userID: User.ID


    init(name: String, lat: Double, long: Double, userID: User.ID) {
        self.name = name
        self.lat = lat
        self.long = long
        self.userID = userID
    }

}

extension GameLocation: PostgreSQLModel {}
extension GameLocation: Content {}
extension GameLocation: Parameter {}


extension GameLocation {
    // From vapor docs -- "Imagine the children relation as Children<Parent, Child> or Children<From, To>. Here we are relating from the user type to the pet type."
    var games: Children<GameLocation, Game> {
        return children(\.gameLocationID)
    }

    var user: Parent<GameLocation, User> {
        return parent(\.userID)
    }
}

extension GameLocation: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        
        return Database.create(self, on: connection)
        { builder in
            try addProperties(to: builder)
           builder.reference(from: \.userID, to: \User.id)
        }
    }
}


