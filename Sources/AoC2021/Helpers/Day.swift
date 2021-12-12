protocol Day {
    static var input: String { get }
    static var day: Int { get }

    static func solution1() async throws -> Int
    static func solution2() async throws -> Int
}

extension Day {
    static func lines() -> [Substring] {
        input.split(separator: "\n")
    }

    static func output(indent: Int = 0) async throws -> String {
        let initialIndent = String(repeating: " ", count: indent)
        var output = initialIndent
        output.append(contentsOf: "⭐️ Day \(day) ⭐️\n")
        output.append(contentsOf: initialIndent.appending("  "))
        try await output.append(contentsOf: "1️⃣: \(solution1())\n")
        output.append(contentsOf: initialIndent.appending("  "))
        try await output.append(contentsOf: "2️⃣: \(solution2())\n")
        output.append(contentsOf: String(repeating: "-", count: 20))
        return output
    }
}
