import Foundation


extension String {
    func lines() -> [Substring] {
        split(separator: "\n")
    }
}


extension Optional {
    struct UnwrapError: Error, LocalizedError {
        init(_ errorDescription: String? = nil, file: StaticString = #file, function: String = #function, line: UInt = #line) {
            self.errorDescription = (errorDescription.map { $0 + "\n" } ?? "")
                + "\(file), \(function), line \(line)"
        }

        var errorDescription: String?
    }

    func orThrow(_ error: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else { throw error() }
        return value
    }

    func orThrow(file: StaticString = #file, function: String = #function, line: UInt = #line) throws -> Wrapped {
        try self.orThrow(UnwrapError(file: file, function: function, line: line))
    }

    func orThrow(_ description: @autoclosure () -> String, file: StaticString = #file, function: String = #function, line: UInt = #line) throws -> Wrapped {
        try self.orThrow(UnwrapError(description(), file: file, function: function, line: line))
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

    func count(where predicate: (Element) -> Bool) -> Int {
        self.reduce(0) { count, element in
            count + (predicate(element) ? 1 : 0)
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    func slices(ofMaxSize maxSize: Int) -> [SubSequence] {
        var buffer = self[...]
        var slices = [SubSequence]()
        while !buffer.isEmpty {
            slices.append(buffer.prefix(maxSize))
            guard buffer.count > maxSize else {
                slices.append(buffer)
                return slices
            }
            buffer.removeFirst(maxSize)
        }
        return slices
    }
}

func comparing<Element, T: Comparable>(
    _ comparator: @escaping (Element) -> T,
    by compare: @escaping (T, T) -> Bool = { $0 < $1 }
) -> (Element, Element) -> Bool {
    { lhs, rhs in
        let (lhsT, rhsT) = (comparator(lhs), comparator(rhs))
        return compare(lhsT, rhsT)
    }
}
