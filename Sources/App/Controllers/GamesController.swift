import Vapor

struct GamesController: RouteCollection {
    func boot(router: Router) throws {
        let gamesRoute = router.grouped("api", "games")
        gamesRoute.post(Game.self, use: createHandler)
        gamesRoute.get(use: getAllHandler)
        gamesRoute.get(Game.parameter, use: getHandler)
        gamesRoute.put(Game.parameter, use: updateHandler)
        gamesRoute.get("gameLocation", use: getGameLocationHandler)
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

    func updateHandler (_ req: Request) throws -> Future<Game> {
        return try flatMap(to: Game.self, req.parameters.next(Game.self), req.content.decode(Game.self))
        { game, updatedGame in
            game.date = updatedGame.date
            game.gameLocationID = updatedGame.gameLocationID
            return game.save(on: req)
        }
    }

    func getGameLocationHandler(_ req: Request) throws -> Future<GameLocation> {
        return try req
        .parameters.next(Game.self)
            .flatMap(to: GameLocation.self) { game in
                game.gameLocation.get(on: req)
        }
    }


}
