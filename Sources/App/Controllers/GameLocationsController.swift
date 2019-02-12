import Vapor
import Fluent

struct GameLocationsController: RouteCollection {
    func boot(router: Router) throws {
        let gameLocationsRoutes = router.grouped("api", "gameLocations")
        gameLocationsRoutes.get(use: getAllHandler)
        gameLocationsRoutes.get(GameLocation.parameter, use: getHandler)
        gameLocationsRoutes.put(GameLocation.parameter, use: updateHandler)
        gameLocationsRoutes.post(GameLocation.self, use: createHandler)
        gameLocationsRoutes.delete(GameLocation.parameter, use: deleteHandler)
        gameLocationsRoutes.get("search", use: searchHandler)
        gameLocationsRoutes.get("first", use: getFirstHandler)
        gameLocationsRoutes.get("sorted", use: sortHandler)
        gameLocationsRoutes.get(GameLocation.parameter, "games", use: getGamesHandler)

    }


    func createHandler(_ req: Request, gameLocation: GameLocation)  throws ->Future<GameLocation> {
       return gameLocation.save(on: req)
    }

    func getAllHandler(_ req: Request) throws -> Future<[GameLocation]> {
        return GameLocation.query(on: req).all()
    }

    // Get one game location
    func getHandler(_ req: Request) throws -> Future<GameLocation> {
        return try req.parameters.next(GameLocation.self)
    }

    // Update a game location
    func updateHandler(_ req: Request) throws -> Future<GameLocation> {
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
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(GameLocation.self)
            .delete(on: req)
            .transform(to: HTTPStatus.noContent)
    }

    // Filter game locations
    func searchHandler(_ req: Request) throws -> Future<[GameLocation]> {
        guard let searchTerm = req.query[String.self, at:"term"] else {
            throw Abort(.badRequest)
        }
        return GameLocation.query(on: req).filter(\.name == searchTerm).all()
    }

    // GET first game location
    func getFirstHandler(_ req: Request) throws -> Future<GameLocation> {
        return GameLocation.query(on: req).first().map(to: GameLocation.self) { gameLocation in
            guard let gameLocation = gameLocation else {
                throw Abort(.notFound)
            }
            return gameLocation
        }
    }

    // Sort game locations
    func sortHandler(_ req: Request) throws -> Future<[GameLocation]> {
        return GameLocation.query(on: req)
            .sort(\.name, .ascending)
            .all()
    }

    func getGamesHandler(_ req: Request) throws -> Future<[Game]> {
        return try req
        .parameters.next(GameLocation.self)
            .flatMap(to: [Game].self) { location in
            try location.games.query(on: req).all()
        }
    }
}
