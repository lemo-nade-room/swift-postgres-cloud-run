import Fluent
import Foundation

final class Access: Model, @unchecked Sendable {
    static let schema = "accesses"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }
}
