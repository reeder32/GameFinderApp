import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.post("api", "games") { req ->Future<GameLocation> in
        return try req.content.decode(GameLocation.self)
            .flatMap(to: GameLocation.self) { gameLocation in
                return gameLocation.save(on: req)
        }
    }
}
