import Vapor
import Fluent

let baseSearch = "api/gameLocations"
/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.post(baseSearch) { req ->Future<GameLocation> in
        return try req.content.decode(GameLocation.self)
            .flatMap(to: GameLocation.self) { gameLocation in
                return gameLocation.save(on: req)
        }
    }

    // Get all game locations
    router.get(baseSearch) { req ->Future<[GameLocation]> in
        return GameLocation.query(on: req).all()
    }

    // Get one game location
    router.get(baseSearch, GameLocation.parameter) {
        req -> Future<GameLocation> in
        return try req.parameters.next(GameLocation.self)
    }

    // Update a game location
    router.put(baseSearch, GameLocation.parameter) {
        req -> Future<GameLocation> in
        return try flatMap(to: GameLocation.self,
        req.parameters.next(GameLocation.self),
        req.content.decode(GameLocation.self)) {
            gameLocation, updatedGameLocation in
            gameLocation.name = updatedGameLocation.name
            gameLocation.lat = updatedGameLocation.lat
            gameLocation.long = updatedGameLocation.long

            return gameLocation.save(on: req)
        }
    }

    // Delete a game location
    router.delete(baseSearch, GameLocation.parameter) {
        req -> Future<HTTPStatus> in
        return try req.parameters.next(GameLocation.self)
        .delete(on: req)
        .transform(to: HTTPStatus.noContent)
    }

    // Filter game locations
    router.get(baseSearch, "search") {
        req -> Future<[GameLocation]> in
        guard let searchTerm = req.query[String.self, at:"term"] else {
            throw Abort(.badRequest)
        }
        return GameLocation.query(on: req).filter(\.name == searchTerm).all()
    }

    // GET first game location
    router.get(baseSearch, "first") { req -> Future<GameLocation> in
        return GameLocation.query(on: req).first().map(to: GameLocation.self) { gameLocation in
            guard let gameLocation = gameLocation else {
                throw Abort(.notFound)
            }
            return gameLocation
        }
    }

    // Sort game locations
    router.get(baseSearch, "sorted") { req -> Future<[GameLocation]> in
        return GameLocation.query(on: req)
        .sort(\.name, .ascending)
        .all()
    }
}
