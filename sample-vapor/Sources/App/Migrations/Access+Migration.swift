import Fluent

extension Access {
    struct Migration: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema("accesses")
                .id()
                .field("created_at", .datetime, .required)
                .create()
        }

        func revert(on database: any Database) async throws {
            try await database.schema("accesses").delete()
        }
    }
}
