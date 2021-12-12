import Foundation


extension String {
    func lines() -> [Substring] {
        split(separator: "\n")
    }
}


extension Optional {
    struct UnwrapError: Error, LocalizedError {
        init(_ errorDescription: String? = nil) {
            self.errorDescription = errorDescription
        }

        var errorDescription: String?
    }

    func orThrow(_ error: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else { throw error() }
        return value
    }

    func orThrow() throws -> Wrapped {
        try self.orThrow(UnwrapError())
    }

    func orThrow(_ description: String) throws -> Wrapped {
        try self.orThrow(UnwrapError(description))
    }
}
