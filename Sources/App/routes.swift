import Vapor
import Fluent

let baseSearch = "api/gameLocations"
/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let gameLocationsController = GameLocationsController()
    try router.register(collection: gameLocationsController)

    let gamesController = GamesController()
    try router.register(collection: gamesController)
   
}
