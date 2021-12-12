extension Sequence {
    func asyncMap<Output>(_ transform: (Element) async throws -> Output) async rethrows -> [Output] {
        var result = [Output]()
        for element in self {
            try await result.append(transform(element))
        }
        return result
    }
}


struct LazyAsyncMapSequence<Upstream: LazySequenceProtocol, Element>: AsyncSequence {
    let upstream: Upstream

    let transform: (Upstream.Element) async throws -> Element

    struct AsyncIterator: AsyncIteratorProtocol {
        var upstream: Upstream.Iterator
        let transform: (Upstream.Element) async throws -> Element

        mutating func next() async throws -> Element? {
            guard let element = upstream.next() else { return nil }
            return try await transform(element)
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        .init(upstream: upstream.makeIterator(), transform: transform)
    }
}


extension LazySequence {
    func asyncMap<Output>(
        _ transform: @escaping (Element) async throws -> Output
    ) -> LazyAsyncMapSequence<Self, Output> {
        .init(upstream: self, transform: transform)
    }
}
