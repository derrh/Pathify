//
//  Router.swift
//  Pathify
//
//  Created by Derrick Hathaway on 1/31/15.
//
//

import Foundation

public struct Router<R> {
    var routes: [String->R?] = []
    
    public mutating func addRoute<T>(#path: Path<T>, action: T->R) {
        let route: String->R? = { pathToRoute in
            if let match = path.match(pathToRoute) {
                return action(match.parameters)
            }
            return nil
        }
        routes.append(route)
    }
    
    public init() {
        self.routes = []
    }
    
    public init(routes: [String->R?]) {
        self.routes = routes
    }
    
    public func route(path: String) -> R? {
        for route in routes {
            if let r = route(path) {
                return r
            }
        }
        
        return nil
    }
}