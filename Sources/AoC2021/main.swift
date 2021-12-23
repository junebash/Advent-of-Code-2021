let completedDays: [Day.Type] = [
    Day1.self,
    Day2.self,
    Day3.self,
    Day4.self,
    Day5.self,
    Day6.self,
    Day7.self,
    Day8.self,
]

do {
    let output = try completedDays.lazy
        .map { try $0.output(indent: 0) }
        .joined(separator: "\n")
    print(output)
} catch {
    print("⚠️ ERROR! ⚠️")
    print(error)
}
