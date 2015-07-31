//
//  Path.swift
//  Pathify
//
//  Created by Derrick Hathaway on 1/31/15.
//
//

import Foundation

prefix operator / {}

public struct Path<T> {
    public init(path: T->String, match: String->T?) {
        self.path = path
        self.match = match
    }
    public let path: T->String
    public let match: String->T?
}

public let ROOT = Path<()>(path: { _ in return "/" }, match: { path in
    if path == "/" {
        return ()
    }
    return nil
})

public func path(component: String) -> Path<()> {
    return Path(path: {_ in component }, match: { path in
        print("\(path) == \(component)")
        
        if path == component {
            return ()
        }
        return nil
    })
}

public func path<T>(component: String->T?) -> Path<T> {
    return Path(path: { t in
        return toString(t)
        }, match: { path in
            if let t = component(path) {
                return t
            }
            
            return nil
    })
}

public prefix func /(component: String) -> Path<()> {
    return ROOT / component
}

public prefix func /<T>(component: String->T?) -> Path<T> {
    return ROOT / component
}

public func /<T>(lhs: Path<T>, rhs: String) -> Path<T> {
    return Path(path: { t in
        let superPath: String = lhs.path(t)
        return superPath.stringByAppendingPathComponent(rhs)
        }, match: { path in
            let last = path.lastPathComponent
            
            if last == rhs {
                let superPath = path.stringByDeletingLastPathComponent
                return lhs.match(superPath)
            }
            
            return nil
    })
}


public func /<T>(lhs: Path<()>, rhs: String->T?) -> Path<T> {
    return Path(path: { t in
        let superPath: String = lhs.path()
        return superPath.stringByAppendingPathComponent(toString(t))
        }, match: { path in
            let last = path.lastPathComponent
            
            if let t = rhs(last) {
                let superPath = path.stringByDeletingLastPathComponent
                if let _: () = lhs.match(superPath) {
                    return t
                }
            }
            
            return nil
    })
}

public func /(lhs: String, rhs: String) -> Path<()> {
    return path(lhs) / rhs
}

public func /<T>(lhs: String->T?, rhs: String) -> Path<T> {
    return path(lhs) / rhs
}

public func /<A, B>(lhs: String->A?, rhs: String->B?) -> Path<(A, B)> {
    return path(lhs) / rhs
}

public func /<A, B>(lhs: Path<A>, rhs: String->B?) -> Path<(A,B)> {
    return Path(path: { a, b in
        let superPath: String = lhs.path(a)
        return superPath.stringByAppendingPathComponent(toString(b))
        }, match: { path in
            let last = path.lastPathComponent
            
            if let b = rhs(last) {
                let superPath = path.stringByDeletingLastPathComponent
                if let a = lhs.match(superPath) {
                    return (a, b)
                }
            }
            
            return nil
    })
}

public func /<A, B, C>(lhs: Path<(A, B)>, rhs: String->C?) -> Path<(A, B, C)> {
    return Path(path: { a, b, c in
        let superPath: String = lhs.path(a, b)
        return superPath.stringByAppendingPathComponent(toString(c))
        }, match: { path in
            let last = path.lastPathComponent
            
            if let c = rhs(last) {
                let superPath = path.stringByDeletingLastPathComponent
                if let (a, b) = lhs.match(superPath) {
                    return (a, b, c)
                }
            }
            
            return nil
    })
}

public func /<A, B, C, D>(lhs: Path<(A, B, C)>, rhs: String->D?) -> Path<(A, B, C, D)> {
    return Path(path: { a, b, c, d in
        let superPath: String = lhs.path(a, b, c)
        return superPath.stringByAppendingPathComponent(toString(d))
        }, match: { path in
            let last = path.lastPathComponent
            
            if let d = rhs(last) {
                let superPath = path.stringByDeletingLastPathComponent
                if let (a, b, c) = lhs.match(superPath) {
                    return (a, b, c, d)
                }
            }
            
            return nil
    })
}

public func /<A, B, C, D, E>(lhs: Path<(A, B, C, D)>, rhs: String->E?) -> Path<(A, B, C, D, E)> {
    return Path(path: { a, b, c, d, e in
        let superPath: String = lhs.path(a, b, c, d)
        return superPath.stringByAppendingPathComponent(toString(e))
        }, match: { path in
            let last = path.lastPathComponent
            
            if let e = rhs(last) {
                let superPath = path.stringByDeletingLastPathComponent
                if let (a, b, c, d) = lhs.match(superPath) {
                    return (a, b, c, d, e)
                }
            }
            
            return nil
    })
}

public func /<A, B, C, D, E, F>(lhs: Path<(A, B, C, D, E)>, rhs: String->F?) -> Path<(A, B, C, D, E, F)> {
    return Path(path: { a, b, c, d, e, f in
        let superPath: String = lhs.path(a, b, c, d, e)
        return superPath.stringByAppendingPathComponent(toString(e))
        }, match: { path in
            let last = path.lastPathComponent
            
            if let f = rhs(last) {
                let superPath = path.stringByDeletingLastPathComponent
                if let (a, b, c, d, e) = lhs.match(superPath) {
                    return (a, b, c, d, e, f)
                }
            }
            
            return nil
    })
}


public let AnyInt: String->Int? = { ($0 as NSString).integerValue }
public let AnyString: String->String? = { return $0 }
private let doubleFormatter: NSNumberFormatter = {
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .DecimalStyle
    return formatter
    }()
public let AnyDouble: String->Double? = { return doubleFormatter.numberFromString($0)?.doubleValue }

