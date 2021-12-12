import Foundation
import Parsing


enum Day6: Day {
    static let day: Int = 6

    struct LanternFish: Hashable {
        let id: UUID

        private(set) var timer: Int

        init(id: UUID = UUID(), timer: Int = 8) {
            self.id = id
            self.timer = timer
        }

        mutating func tick() -> LanternFish? {
            if timer == 0 {
                timer = 6
                return LanternFish()
            } else {
                timer -= 1
                return nil
            }
        }

        fileprivate static let parser = Parsers.IntParser<Substring.UTF8View, Int>()
            .map { LanternFish(timer: $0) }
    }

    struct School {
        var rawValue: [Int: Int]

        var fish: [LanternFish] {
            rawValue.flatMap { (timer, count) in
                (0..<count).map { _ in LanternFish(timer: timer) }
            }
        }

        var count: Int {
            rawValue.values.reduce(into: 0, +=)
        }

        init(fish: [LanternFish]) {
            self.rawValue = fish.reduce(into: [:], { partialResult, fish in
                partialResult[fish.timer, default: 0] += 1
            })
        }

        mutating func tick() {
            var newValues = [Int: Int]()
            for (timerValue, count) in rawValue {
                if timerValue == 0 {
                    newValues[6, default: 0] += count
                    newValues[8] = count
                } else {
                    newValues[timerValue - 1, default: 0] += count
                }
            }
            self.rawValue = newValues
        }

        fileprivate static let parser = Many(LanternFish.parser, separator: ",".utf8)
            .map { School(fish: $0) }
    }

    static func solution1() throws -> Int {
        var school = try School.parser.parse(input)
            .orThrow(AdventError("failed to parse lantern fish school"))
        for _ in 1...80 {
            school.tick()
        }
        return school.count
    }

    static func solution2() throws -> Int {
        var school = try School.parser.parse(input)
            .orThrow(AdventError("failed to parse lantern fish school"))
        for _ in 1...256 {
            school.tick()
        }
        return school.count
    }

    static let input: String = """
        1,1,1,2,1,5,1,1,2,1,4,1,4,1,1,1,1,1,1,4,1,1,1,1,4,1,1,5,1,3,1,2,1,1,1,2,1,1,1,4,1,1,3,1,5,1,1,1,1,3,5,5,2,1,1,1,2,1,1,1,1,1,1,1,1,5,4,1,1,1,1,1,3,1,1,2,4,4,1,1,1,1,1,1,3,1,1,1,1,5,1,3,1,5,1,2,1,1,5,1,1,1,5,3,3,1,4,1,3,1,3,1,1,1,1,3,1,4,1,1,1,1,1,2,1,1,1,4,2,1,1,5,1,1,1,2,1,1,1,1,1,1,1,1,2,1,1,1,1,1,5,1,1,1,1,3,1,1,1,1,1,3,4,1,2,1,3,2,1,1,2,1,1,1,1,4,1,1,1,1,4,1,1,1,1,1,2,1,1,4,1,1,1,5,3,2,2,1,1,3,1,5,1,5,1,1,1,1,1,5,1,4,1,2,1,1,1,1,2,1,3,1,1,1,1,1,1,2,1,1,1,3,1,4,3,1,4,1,3,2,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,2,1,5,1,1,1,1,2,1,1,1,3,5,1,1,1,1,5,1,1,2,1,2,4,2,2,1,1,1,5,2,1,1,5,1,1,1,1,5,1,1,1,2,1
        """
}
