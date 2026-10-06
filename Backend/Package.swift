// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "DragonBallBackend",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "Run", targets: ["Run"])],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.12.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.9.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/sql-kit.git", from: "3.32.0"),
    ],
    targets: [
        .target(name: "CardRules"),
        .target(name: "App", dependencies: [
            "CardRules",
            .product(name: "SQLKit", package: "sql-kit"),
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "JWTKit", package: "jwt-kit"),
        ]),
        .executableTarget(name: "Run", dependencies: ["App"]),
        .testTarget(name: "CardRulesTests", dependencies: ["CardRules"]),
        .testTarget(name: "AppTests", dependencies: ["App", "CardRules",
            .product(name: "XCTVapor", package: "vapor"),
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
        ]),
    ]
)
