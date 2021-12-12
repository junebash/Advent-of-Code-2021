let completedDays: [Day.Type] = [
    Day1.self,
    Day2.self,
    Day3.self,
    Day4.self,
    Day5.self,
    Day6.self,
    Day7.self,
]

func main() async {
    do {
        let output = try await completedDays.lazy
            .asyncMap { try await $0.output(indent: 0) }
            .joined(separator: "\n")
        print(output)
    } catch {
        print("⚠️ ERROR! ⚠️")
        print(error)
    }
}

Task { }
