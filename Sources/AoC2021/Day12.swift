import Parsing

private struct Cave: Identifiable, Hashable {
    let id: Substring

    var isSmall: Bool { id.first!.isLowercase }
    var isBig: Bool { id.first!.isUppercase }
    var isStart: Bool { id == "start" }
    var isEnd: Bool { id == "end" }

    static let start: Cave = .init(id: "start")
    static let end: Cave = .init(id: "end")
}


private struct CaveMap {
    let caves: Set<Cave>
    let connections: [Cave: [Cave]]

    init(connections: [(Cave, Cave)]) {
        var caves = Set<Cave>()
        var connectedCaves = [Cave: Set<Cave>]()
        for (cave1, cave2) in connections {
            caves.insert(cave1)
            caves.insert(cave2)
            connectedCaves[cave1, default: []].insert(cave2)
            connectedCaves[cave2, default: []].insert(cave1)
        }
        self.caves = caves
        self.connections = connectedCaves.mapValues(Array.init)
    }

    func allValidPaths() -> Set<[Cave]> {
        func _allValidPaths(from current: Cave, visitedSmallCaves: inout Set<Cave>) -> Set<[Cave]> {
            if current.isSmall {
                visitedSmallCaves.insert(current)
            }
            return Set(
                (connections[current] ?? []).lazy
                    .filter { [visitedSmallCaves] in !visitedSmallCaves.contains($0) }
                    .flatMap { [visitedSmallCaves] option -> Set<[Cave]> in
                        var visitedSmallCaves = visitedSmallCaves
                        return option == .end
                            ? [[current, option]]
                            : _allValidPaths(from: option, visitedSmallCaves: &visitedSmallCaves)
                                .reduce(into: Set()) { partialResult, path in
                                    partialResult.insert([current] + path)
                                }
                    }
            )
        }

        var visitedSmallCaves = Set<Cave>()
        return _allValidPaths(from: .start, visitedSmallCaves: &visitedSmallCaves)
    }

    func allValidPaths2() -> Set<[Cave]> {
        func _allValidPaths2(
            pathPrefix: [Cave],
            visitedSmallCaves: inout [Cave: UInt8],
            validPaths: inout Set<[Cave]>
        ) {
            let current = pathPrefix.last!
            if current.isSmall {
                let currentVisitCount = visitedSmallCaves[current]
                switch currentVisitCount {
                case _ where current == .end:
                    validPaths.insert(pathPrefix)
                    return
                case 0, .none:
                    visitedSmallCaves[current] = 1
                case 1 where !visitedSmallCaves.values.contains(2):
                    visitedSmallCaves[current] = 2
                default:
                    return
                }
            }
            guard visitedSmallCaves.values.count(where: { $0 >= 2 }) <= 1 else { return }
            for option in self.connections[current] ?? [] where option != .start {
                var subPathVisitedSmallCaves = visitedSmallCaves
                _allValidPaths2(
                    pathPrefix: pathPrefix + [option],
                    visitedSmallCaves: &subPathVisitedSmallCaves,
                    validPaths: &validPaths
                )
            }
        }

        var visitedSmallCaves = [Cave: UInt8]()
        var validPaths = Set<[Cave]>()
        _allValidPaths2(pathPrefix: [.start], visitedSmallCaves: &visitedSmallCaves, validPaths: &validPaths)
        return validPaths
//            .filter { path in
//                let counts = path.reduce(into: [Cave: Int]()) { partialResult, cave in
//                    partialResult[cave, default: 0] += 1
//                }
//                return !counts.values.contains { $0 >= 3 }
//                    && counts[.start] == 1
//                    && counts[.end] == 1
//                    && counts.values.count(where: { $0 == 2 }) <= 1
//            }
    }
}


private let caveParser = Prefix<Substring>(while: \.isLetter)
    .map(Cave.init(id:))
    .utf8
private let connectionParser = caveParser
    .skip("-".utf8)
    .take(caveParser)
private let mapParser = Many(connectionParser, separator: "\n".utf8)
    .map(CaveMap.init(connections:))


enum Day12: Day {
    static let day: Int = 12

    static func solution1() throws -> Int {
        let map = try mapParser.parse(input).orThrow()
        return map.allValidPaths().count
    }

    static func solution2() throws -> Int {
        let map = try mapParser.parse(input).orThrow()
        return map.allValidPaths2().count
    }

    static let input: String = """
        HF-qu
        end-CF
        CF-ae
        vi-HF
        vt-HF
        qu-CF
        hu-vt
        CF-pk
        CF-vi
        qu-ae
        ae-hu
        HF-start
        vt-end
        ae-HF
        end-vi
        vi-vt
        hu-start
        start-ae
        CS-hu
        CF-vt
        """
}
