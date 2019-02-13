//
//  UsersController.swift
//  App
//
//  Created by Nick Reeder on 2/12/19.
//

import Vapor

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")
        usersRoute.post(User.self, use: createHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.get(User.parameter, use: getHandler)
        usersRoute.get(User.parameter, "gameLocations", use: getGameLocationsHandler)
    }

    func createHandler(_ req: Request, user: User) throws -> Future<User> {
        return user.save(on: req)
    }

    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }

    func getHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }

    func getGameLocationsHandler(_ req: Request) throws -> Future<[GameLocation]> {
        return try req
        .parameters.next(User.self)
            .flatMap(to: [GameLocation].self) { user in
                try user.gameLocations.query(on: req).all()
        }
    }
}
