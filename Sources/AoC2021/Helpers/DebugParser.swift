import Parsing

struct DebugParser<Upstream: Parser>: Parser {
    let upstream: Upstream

    func parse(_ input: inout Upstream.Input) -> Upstream.Output? {
        print(upstream)
        print("Input:", input)
        let output = upstream.parse(&input)
        if let output = output {
            print("Output:", output)
            print("Next input:", input)
        } else {
            print("Parsing failed")
        }
        return output
    }
}

extension Parser {
    func debug() -> DebugParser<Self> {
        .init(upstream: self)
    }
}
