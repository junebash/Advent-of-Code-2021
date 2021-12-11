import Foundation

struct AdventError: Error, LocalizedError {
    var errorDescription: String

    init(_ errorDescription: String) {
        self.errorDescription = ["❗️", errorDescription, "❗️"].joined()
    }
}
