import Parsing
import Foundation


private final class Octopus: Hashable {
    private(set) var energyLevel: UInt8
    private(set) var neighbors: Set<Octopus> = []
    private(set) var isFlashing: Bool = false
    private(set) var totalFlashes: Int = 0

    var attributedDescription: AttributedString {
        energyLevel == 0
            ? try! AttributedString(markdown: "**0**")
            : AttributedString(String(energyLevel))
    }

    init(initialEnergy: UInt8) {
        self.energyLevel = initialEnergy
    }

    func addNeighbor(_ neighbor: Octopus) {
        self.neighbors.insert(neighbor)
        neighbor.neighbors.insert(self)
    }

    func increment() {
        guard !isFlashing else { return }
        energyLevel += 1
        if energyLevel == 10 {
            isFlashing = true
            totalFlashes += 1
            for neighbor in neighbors {
                neighbor.increment()
            }
        }
    }

    func endStep() {
        if isFlashing {
            isFlashing = false
            energyLevel = 0
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Octopus, rhs: Octopus) -> Bool {
        lhs === rhs
    }

    static let parser = Prefix(1, while: !\.isWhitespace)
        .utf8
        .pipe(UInt8.parser())
        .map(Octopus.init(initialEnergy:))
}


private final class OctopusGraph {
    let octopi: [[Octopus]]
    private(set) var currentStep: Int = 1

    var allOctopiDidFlash: ((_ step: Int) -> Void)?

    var totalFlashes: Int {
        octopi.joined().lazy
            .map(\.totalFlashes)
            .reduce(into: 0, +=)
    }

    var attributedDescription: AttributedString {
        octopi.lazy.map { row in
            row.lazy.map { octopus in
                octopus.attributedDescription
            }.reduce(into: AttributedString(), +=)
        }.reduce(into: AttributedString(), { result, row in
            result.append(AttributedString("\n"))
            result.append(row)
        })
    }

    var description: String {
        octopi.lazy.map { row in
            row.lazy.map { octopus in
                String(octopus.energyLevel)
            }.reduce(into: "", +=)
        }.joined(separator: "\n")
    }

    init(octopi: [[Octopus]]) {
        self.octopi = octopi

        for (y, row) in zip(octopi.indices, octopi) {
            for (x, octopus) in zip(row.indices, row) {
                getNeighbors(atX: x, y: y).forEach(octopus.addNeighbor(_:))
            }
        }
    }

    func step() {
        let allOctopi = octopi.joined()
        for octopus in allOctopi {
            octopus.increment()
        }
        var flashCount = 0
        for octopus in allOctopi {
            if octopus.isFlashing {
                flashCount += 1
            }
            octopus.endStep()
        }
        if flashCount == allOctopi.count {
            self.allOctopiDidFlash?(currentStep)
        }
        currentStep += 1
    }

    private func getNeighbors(atX x: Int, y: Int) -> Set<Octopus> {
        var result = Set<Octopus>()
        for xOffset in -1...1 {
            for yOffset in -1...1 where (xOffset != 0 || yOffset != 0) {
                guard let o = octopi[safe: y + yOffset]?[safe: x + xOffset] else { continue }
                result.insert(o)
            }
        }
        return result
    }

    static let parser = Many(
        Many(Octopus.parser),
        separator: "\n".utf8
    ).map(OctopusGraph.init(octopi:))
}


enum Day11: Day {
    static let day: Int = 11

    static func solution1() throws -> Int {
        let graph = try OctopusGraph.parser
            .parse(input)
            .orThrow()
        for _ in 1...100 {
            graph.step()
        }
        return graph.totalFlashes
    }

    static func solution2() throws -> Int {
        let graph = try OctopusGraph.parser
            .parse(input)
            .orThrow()
        var allOctopiFlashStep: Int?
        graph.allOctopiDidFlash = { allOctopiFlashStep = $0 }
        while allOctopiFlashStep == nil {
            graph.step()
        }
        return allOctopiFlashStep!
    }

    static let input: String = """
        4658137637
        3277874355
        4525611183
        3128125888
        8734832838
        4175463257
        8321423552
        4832145253
        8286834851
        4885323138
        """
}
