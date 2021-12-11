extension String {
    func lines() -> [Substring] {
        split(separator: "\n")
    }
}

extension Optional {
    struct UnwrapError: Error {}

    func orThrow(_ error: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else { throw error() }
        return value
    }

    func orThrow() throws -> Wrapped {
        try self.orThrow(UnwrapError())
    }
}
