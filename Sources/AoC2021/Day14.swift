import Parsing
import Foundation


private struct Polymer {
    let rawValue: [Character]

    static let parser = Prefix<Substring>(while: \.isLetter)
        .map(Array.init)
        .map(Polymer.init)
}


private struct Instruction {
    let first, second: Character
    let insert: Character

    static let parser = First<Substring>()
        .take(First())
        .skip(" -> ")
        .take(First())
        .map(Instruction.init)
}


private struct PolymerCreator {
    var polymer: [Character]
    let instructionLookup: [Pair<Character>: Character]

    var charCounts: [Character: Int] {
        polymer.reduce(into: [:]) { partialResult, char in
            partialResult[char, default: 0] += 1
        }
    }

    var solution1: Int {
        guard let (min, max) = charCounts.values.minMax() else { return 0 }
        return max - min
    }

    init(polymer: Polymer, instructions: [Instruction]) {
        self.polymer = polymer.rawValue
        self.instructionLookup = instructions.reduce(into: [:], {
            $0[Pair(first: $1.first, second: $1.second)] = $1.insert
        })
    }

    static let parser = Polymer.parser.utf8
        .skip(Newline())
        .skip(Newline())
        .take(Many(Instruction.parser.utf8, separator: Newline()))
        .map(PolymerCreator.init)

    mutating func commitInstructions() {
        var inserts: [Int: Character] = [:]
        for (firstIndex, secondIndex) in zip(polymer.indices, polymer.dropFirst().indices) {
            let (first, second) = (polymer[firstIndex], polymer[secondIndex])
            if let newInsert = instructionLookup[Pair(first: first, second: second)] {
                inserts[secondIndex] = newInsert
            }
        }

        for (index, char) in inserts.sorted(using: .keyPath(\.key, order: .reverse)) {
            polymer.insert(char, at: index)
        }
    }
}


enum Day14: Day {
    static let day: Int = 14

    static func solution1() throws -> Int {
        var gen = try PolymerCreator.parser.parse(input).orThrow()
        for _ in 1...10 {
            gen.commitInstructions()
        }
        return gen.solution1
    }

    static func solution2() throws -> Int {
//        var gen = try PolymerCreator.parser.parse(input).orThrow()
//        for i in 1...40 {
//            let now = Date.now
//            print("step", i)
//            gen.commitInstructions()
//            let then = Date.now
//            print(then.timeIntervalSinceReferenceDate - now.timeIntervalSinceReferenceDate)
//        }
//        return gen.solution1
        return 0
    }

    static let input: String = """
        COPBCNPOBKCCFFBSVHKO

        NS -> H
        FS -> O
        PO -> C
        NV -> N
        CK -> B
        FK -> N
        PS -> C
        OF -> F
        KK -> F
        PP -> S
        VS -> K
        VB -> V
        BP -> P
        BB -> K
        BF -> C
        NN -> V
        NO -> F
        SV -> C
        OK -> N
        PH -> P
        KV -> B
        PN -> O
        FN -> V
        SK -> V
        VC -> K
        BH -> P
        BO -> S
        HS -> H
        HK -> S
        HC -> S
        HF -> B
        PC -> C
        CF -> B
        KN -> H
        CS -> N
        SP -> O
        VH -> N
        CC -> K
        KP -> N
        NP -> C
        FO -> H
        FV -> N
        NC -> F
        KB -> N
        VP -> O
        KO -> F
        CP -> F
        OH -> F
        KC -> H
        NB -> F
        HO -> P
        SC -> N
        FF -> B
        PB -> H
        FB -> K
        SN -> B
        VO -> K
        OO -> N
        NF -> B
        ON -> P
        SF -> H
        FP -> H
        HV -> B
        NH -> B
        CO -> C
        PV -> P
        VV -> K
        KS -> P
        OS -> S
        SB -> P
        OC -> N
        SO -> K
        BS -> B
        CH -> V
        PK -> F
        OB -> P
        CN -> N
        CB -> N
        VF -> O
        VN -> K
        PF -> P
        SH -> H
        FH -> N
        HP -> P
        KF -> V
        BK -> H
        OP -> C
        HH -> F
        SS -> V
        BN -> C
        OV -> F
        HB -> P
        FC -> C
        BV -> H
        VK -> S
        NK -> K
        CV -> K
        HN -> K
        BC -> K
        KH -> P
        """
}
