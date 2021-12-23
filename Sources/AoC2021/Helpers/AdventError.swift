import Foundation

struct AdventError: Error, LocalizedError {
    var errorDescription: String

    init(_ errorDescription: String) {
        self.errorDescription = ["❗️", errorDescription, "❗️"].joined()
    }
}

func printError(_ error: Error) {
    print("⚠️ ERROR! ⚠️")
    print(error)
}
