struct Pair<T> {
    let first, second: T
}

extension Pair: Equatable where T: Equatable {}
extension Pair: Hashable where T: Hashable {}
