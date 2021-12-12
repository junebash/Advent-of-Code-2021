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


extension Sequence {
    func minMax() -> (min: Element, max: Element)?
    where Element: Comparable {
        var iterator = makeIterator()
        guard let firstElement = iterator.next() else { return nil }
        var min = firstElement
        var max = firstElement
        while let element = iterator.next() {
            if element < min {
                min = element
            }
            if element > max {
                max = element
            }
        }
        return (min, max)
    }
}
