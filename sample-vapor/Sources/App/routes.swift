import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws -> View in
        let count = try await Access.query(on: req.db).count()
        Task.detached {
            try await Access().create(on: req.db)
        }
        return try await req.view.render("index", ["title": "あなたが\(count + 1)回目の訪問者です！"])
    }
}
