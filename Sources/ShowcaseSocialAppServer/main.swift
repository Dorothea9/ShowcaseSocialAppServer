import Foundation
import Swifter

let server = HttpServer()
let serviceContainer = ServiceContainer()

AuthRoutes.register(on: server, serviceContainer: serviceContainer)
UserRoutes.register(on: server, serviceContainer: serviceContainer)
PostRoutes.register(on: server, serviceContainer: serviceContainer)
LikeRoutes.register(on: server, serviceContainer: serviceContainer)
ProfilePhotoRoutes.register(on: server, serviceContainer: serviceContainer)
StaticRoutes.register(on: server)
SwaggerRoutes.register(on: server)

do {
    let port = 8080
    try server.start(in_port_t(port))
    print("Server running at http://localhost:\(port)")
    RunLoop.main.run()
} catch {
    print("Failed to start server: \(error)")
}
