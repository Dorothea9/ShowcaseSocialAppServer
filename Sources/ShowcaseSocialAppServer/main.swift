import Foundation
import Swifter

let server = HttpServer()
let userService = UserService()
let authService = AuthService()

registerAuthRoutes(on: server, userService: userService, authService: authService)
registerUserRoutes(on: server, userService: userService, authService: authService)
registerPostRoutes(on: server)
registerSwaggerRoutes(on: server)

do {
    let port = 8080
    try server.start(in_port_t(port))
    print("Server running at http://localhost:\(port)")
    RunLoop.main.run()
} catch {
    print("Failed to start server: \(error)")
}
