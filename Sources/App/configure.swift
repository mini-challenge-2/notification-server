import Vapor
import APNS
import APNSCore
import VaporAPNS
import JWT
import Crypto

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    let privateKeyURL = URL(fileURLWithPath: app.directory.publicDirectory + "S95F7MWX5R.p8")
    let privateKeyData = try Data(contentsOf: privateKeyURL)
    let privateKeyString = String(data: privateKeyData, encoding: .utf8)!
    let privateKey = try P256.Signing.PrivateKey(pemRepresentation: privateKeyString)

    // Configure APNS client with JWT authentication
    let apnsConfig = APNSClientConfiguration(
        authenticationMethod: .jwt(
            privateKey: privateKey,
            keyIdentifier: "S95F7MWX5R",
            teamIdentifier: "DJFUU6576B"
        ),
        environment: .sandbox
    )
    
    app.apns.containers.use(
        apnsConfig,
        eventLoopGroupProvider: .shared(app.eventLoopGroup),
        responseDecoder: JSONDecoder(),
        requestEncoder: JSONEncoder(),
        as: .default
    )
    
        // Routes
    try routes(app)
}
