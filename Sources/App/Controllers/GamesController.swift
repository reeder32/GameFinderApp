import Vapor

struct GamesController: RouteCollection {
    func boot(router: Router) throws {
        let gamesRoute = router.grouped("api", "games")
        gamesRoute.post(Game.self, use: createHandler)
        gamesRoute.get(use: getAllHandler)
        gamesRoute.get(Game.parameter, use: getHandler)
        gamesRoute.get(Game.parameter, "gameLocation", use: getGameLocationHandler)
    }

    func createHandler (_ req: Request, game: Game) throws -> Future<Game> {
        return game.save(on: req)
    }

    func getAllHandler (_ req: Request) throws -> Future<[Game]> {
        return Game.query(on: req).all()
    }

    func getHandler (_ req: Request) throws -> Future<Game> {
        return try req.parameters.next(Game.self)
    }

    func getGameLocationHandler(_ req: Request) throws -> Future<[GameLocation]> {
        return try req
        .parameters.next(Game.self)
            .flatMap(to: [GameLocation].self) { game in
                try game.gameLocation.query(on: req).all()
        }
    }
}
