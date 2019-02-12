import Foundation
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

