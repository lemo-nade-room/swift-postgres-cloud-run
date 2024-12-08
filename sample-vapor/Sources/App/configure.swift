import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    var tls: TLSConfiguration {
        var tls: TLSConfiguration = .makeClientConfiguration()
        tls.trustRoots = .certificates([try! .init(
            bytes: Environment.get("CA_CRT")!.base64Decoded(),
            format: .pem
        )])
        tls.privateKey = try! .privateKey(.init(
            bytes: Environment.get("CLIENT_PRIVATE_KEY")!.base64Decoded(),
            format: .pem
        ))
        tls.certificateChain = [try! .certificate(.init(
            bytes: Environment.get("CLIENT_CRT")!.base64Decoded(),
            format: .pem
        ))]
        tls.verifySignatureAlgorithms = [.ed25519]
        tls.certificateVerification = app.environment == .development ? .noHostnameVerification : .fullVerification
        return tls
    }

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .require(try .init(configuration: tls)))
    ), as: .psql)

    app.migrations.add(Access.Migration())

    app.views.use(.leaf)


    // register routes
    try routes(app)
}
