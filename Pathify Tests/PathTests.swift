//
//  PathTests.swift
//  Pathify Tests
//
//  Created by Derrick Hathaway on 1/31/15.
//
//

import Cocoa
import XCTest
import Pathify

private let foo = "foo"
private let bar = "bar"

class PathTests: XCTestCase {
    func test_root() {
        let path = ROOT
        
        XCTAssertEqual(path.path(), "/", "Root path")
        XCTAssertTrue(path.match("/") != nil, "Should match")
        XCTAssertTrue(path.match("") == nil, "Shouldn't match nothing")
        XCTAssertTrue(path.match("//") == nil, "Shouldn't match weird thing like //")
        XCTAssertTrue(path.match("./") == nil, "Another weird thign it shouldn't match ./")
    }
    
    func test_slash_foo() {
        let path = /foo
        
        XCTAssertEqual(path.path(), "/foo", "Recreate the string version of /foo")
        XCTAssertTrue(path.match("/foo") != nil, "Should match /foo")
    }
    
    func test_slash_foo_slash_bar() {
        let path = /foo/bar
        
        XCTAssertEqual(path.path(), "/foo/bar", "pathify")
        XCTAssertTrue(path.match("/foo/bar") != nil, "should match /foo/bar")
        XCTAssertTrue(path.match("foo/bar") == nil, "should not match foo/bar")
    }
    
    func test_foo_slash_bar() {
        let path = foo/bar
        
        XCTAssertEqual(path.path(), "foo/bar", "should yield foo/bar")
        XCTAssertTrue(path.match("foo/bar") != nil, "should match foo/bar")
        XCTAssertTrue(path.match("/foo/bar") == nil, "should not match /foo/bar")
    }
    
    func test_parameterized_paths() {
        let slashInt = /AnyInt
        
        XCTAssertEqual(slashInt.path(12), "/12", "computed path")
        XCTAssertEqual(slashInt.match("/12")?.parameters ?? Int.max, 12, "Should find the 12")
        
        let int = path(AnyInt)
        XCTAssertEqual(int.path(33), "33", "single component")
        XCTAssertEqual(int.match("33")?.parameters ?? Int.max, 33, "just the number 33, everyone")
        
        let slashIntSlashString = slashInt/AnyString
        XCTAssertEqual(slashIntSlashString.path(3, "foo"), "/3/foo", "int and a string path")
        XCTAssertEqual(slashIntSlashString.match("/9/foo")?.parameters.0 ?? 999, 9, "capture 1st parameter")
        XCTAssertEqual(slashIntSlashString.match("/9/foo")?.parameters.1 ?? "cats", "foo", "capture 2nd parameter")
        
        let addStaticComponent = slashInt/bar
        XCTAssertEqual(addStaticComponent.path(8), "/8/bar", "path with an int followed by static string")
        XCTAssertEqual(addStaticComponent.match("/1233/bar")?.parameters ?? Int.max, 1233, "matches the first path componet")
    }
    
    func test_3() {
        let path = AnyInt/AnyInt/AnyInt
        
        XCTAssertEqual(path.path(3, 5, 14), "3/5/14", "what happend on that date?")
        XCTAssertEqual(path.match("3/5/14")?.parameters.0 ?? Int.max, 3, "first component should be 3")
        XCTAssertEqual(path.match("3/5/14")?.parameters.1 ?? Int.max, 5, "first component should be 3")
        XCTAssertEqual(path.match("3/5/14")?.parameters.2 ?? Int.max, 14, "first component should be 3")
    }
    
    func test_4() {
        let path = /AnyInt/AnyInt/AnyInt/AnyInt
        
        XCTAssertEqual(path.path(1, 2, 3, 9), "/1/2/3/9", "should be the path")
        XCTAssertEqual(path.match("/1/2/3/9")?.parameters.0 ?? Int.max, 1, "first component should be 3")
        XCTAssertEqual(path.match("/1/2/3/9")?.parameters.1 ?? Int.max, 2, "first component should be 3")
        XCTAssertEqual(path.match("/1/2/3/9")?.parameters.2 ?? Int.max, 3, "first component should be 3")
        XCTAssertEqual(path.match("/1/2/3/9")?.parameters.3 ?? Int.max, 9, "first component should be 3") // ya I copy/paste... so what?
    }
    
    func test_5() {
        let path = AnyInt/AnyInt/AnyInt/AnyInt/AnyInt
        
        XCTAssertEqual(path.path(1, 2, 3, 4, 88), "1/2/3/4/88", "whatevs")
        XCTAssertEqual(path.match("1/2/3/4/88")?.parameters.0 ?? Int.max, 1, "component should match")
        XCTAssertEqual(path.match("1/2/3/4/88")?.parameters.1 ?? Int.max, 2, "component should match")
        XCTAssertEqual(path.match("1/2/3/4/88")?.parameters.2 ?? Int.max, 3, "component should match")
        XCTAssertEqual(path.match("1/2/3/4/88")?.parameters.3 ?? Int.max, 4, "component should match")
        XCTAssertEqual(path.match("1/2/3/4/88")?.parameters.4 ?? Int.max, 88, "component should match")
    }
}
