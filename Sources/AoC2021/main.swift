let completedDays: [Day.Type] = [
    Day1.self,
    Day2.self,
    Day3.self,
    Day4.self,
    Day5.self,
    Day6.self,
    Day7.self,
    Day8.self,
    Day9.self,
    Day10.self,
    Day11.self,
    Day12.self,
    Day13.self,
    Day14.self,
]

do {
    let output = try completedDays.lazy
        .map { try $0.output(indent: 0) }
        .joined(separator: "\n")
    print(output)
} catch {
    printError(error)
}
