prefix func ! <Root>(keyPath: KeyPath<Root, Bool>) -> (Root) -> Bool {
    { root in !root[keyPath: keyPath] }
}

prefix func ! <Root>(f: @escaping (Root) -> Bool) -> (Root) -> Bool {
    { root in !f(root) }
}
