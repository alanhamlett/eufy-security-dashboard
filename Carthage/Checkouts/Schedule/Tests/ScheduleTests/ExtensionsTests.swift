import XCTest
@testable import Schedule

final class ExtensionsTests: XCTestCase {

    func testClampedToInt() {
        let a = Double(Int.max) + 1
        XCTAssertEqual(a.clampedToInt(), Int.max)

        let b = Double(Int.min) - 1
        XCTAssertEqual(b.clampedToInt(), Int.min)
    }

    func testClampedAdding() {
        let i = Int.max
        XCTAssertEqual(i.clampedAdding(1), Int.max)
    }

    func testStartOfToday() {
        let components = Date().startOfToday.dateComponents

        let h = components.hour
        let m = components.minute
        let s = components.second
        XCTAssertNotNil(h)
        XCTAssertNotNil(m)
        XCTAssertNotNil(s)

        XCTAssertEqual(h, 0)
        XCTAssertEqual(m, 0)
        XCTAssertEqual(s, 0)
    }

    static var allTests = [
        ("testClampedToInt", testClampedToInt),
        ("testClampedAdding", testClampedAdding),
        ("testStartOfToday", testStartOfToday)
    ]
}
