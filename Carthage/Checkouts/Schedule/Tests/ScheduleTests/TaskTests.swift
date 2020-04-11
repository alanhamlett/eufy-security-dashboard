import XCTest
@testable import Schedule

final class TaskTests: XCTestCase {

    let leeway = 0.01.second

    func testMetrics() {
        let e = expectation(description: "testMetrics")
        let date = Date()

        let task = Plan.after(0.01.second, repeating: 0.01.second).do(queue: .global()) {
            e.fulfill()
        }
        XCTAssertTrue(task.creationDate.interval(since: date).isAlmostEqual(to: 0.second, leeway: leeway))

        waitForExpectations(timeout: 0.1)

        XCTAssertNotNil(task.firstExecutionDate)
        XCTAssertTrue(task.firstExecutionDate!.interval(since: date).isAlmostEqual(to: 0.01.second, leeway: leeway))

        XCTAssertNotNil(task.lastExecutionDate)
        XCTAssertTrue(task.lastExecutionDate!.interval(since: date).isAlmostEqual(to: 0.01.second, leeway: leeway))

        XCTAssertEqual(task.executionDates!.count, 1)
    }

    func testAfter() {
        let e = expectation(description: "testSchedule")
        let date = Date()
        let task = Plan.after(0.01.second).do(queue: .global()) {
            XCTAssertTrue(Date().interval(since: date).isAlmostEqual(to: 0.01.second, leeway: self.leeway))
            e.fulfill()
        }
        waitForExpectations(timeout: 0.1)

        _ = task
    }

    func testRepeat() {
        let e = expectation(description: "testRepeat")
        var count = 0
        let task = Plan.every(0.01.second).first(3).do(queue: .global()) {
            count += 1
            if count == 3 { e.fulfill() }
        }
        waitForExpectations(timeout: 0.1)

        _ = task
    }

    func testTaskCenter() {
        let task = Plan.never.do { }
        XCTAssertTrue(task.taskCenter === TaskCenter.default)

        task.removeFromTaskCenter()
        XCTAssertNil(task.taskCenter)

        let center = TaskCenter()
        task.addToTaskCenter(center)
        XCTAssertTrue(task.taskCenter === center)
    }

    func testDispatchQueue() {
        let e = expectation(description: "testQueue")
        let q = DispatchQueue(label: UUID().uuidString)

        let task = Plan.after(0.01.second).do(queue: q) {
            XCTAssertTrue(DispatchQueue.is(q))
            e.fulfill()
        }
        waitForExpectations(timeout: 0.1)

        _ = task
    }

    func testThread() {
        let e = expectation(description: "testThread")
        DispatchQueue.global().async {
            let thread = Thread.current
            let task = Plan.after(0.01.second).do { task in
                XCTAssertTrue(thread === Thread.current)
                e.fulfill()
                task.cancel()
            }
            _ = task
            RunLoop.current.run()
        }
        waitForExpectations(timeout: 0.1)
    }

    func testExecuteNow() {
        let e = expectation(description: "testExecuteNow")
        let task = Plan.never.do {
            e.fulfill()
        }
        task.executeNow()
        waitForExpectations(timeout: 0.1)
    }

    func testReschedule() {
        let e = expectation(description: "testReschedule")
        var i = 0
        let task = Plan.after(0.01.second).do(queue: .global()) { (task) in
            i += 1
            if task.executionCount == 3 && task.estimatedNextExecutionDate == nil {
                e.fulfill()
            }
            if task.executionCount > 3 {
                XCTFail("should never come here")
            }
        }
        DispatchQueue.global().async(after: 0.02.second) {
            task.reschedule(Plan.every(0.01.second).first(2))
        }
        waitForExpectations(timeout: 0.1)
    }

    func testSuspendResume() {
        let task = Plan.never.do { }
        XCTAssertEqual(task.suspensionCount, 0)
        task.suspend()
        task.suspend()
        task.suspend()
        XCTAssertEqual(task.suspensionCount, 3)
        task.resume()
        XCTAssertEqual(task.suspensionCount, 2)
    }

    func testCancel() {
        let task = Plan.never.do { }
        XCTAssertFalse(task.isCancelled)
        task.cancel()
        XCTAssertTrue(task.isCancelled)
    }

    func testAddAndRemoveActions() {
        let e = expectation(description: "testAddAndRemoveActions")
        let task = Plan.after(0.1.second).do { }
        let date = Date()
        let key = task.addAction { _ in
            XCTAssertTrue(Date().timeIntervalSince(date).isAlmostEqual(to: 0.1, leeway: 0.1))
            e.fulfill()
        }
        XCTAssertEqual(task.actionCount, 2)
        waitForExpectations(timeout: 0.5)

        task.removeAction(byKey: key)
        XCTAssertEqual(task.actionCount, 1)

        task.cancel()

        task.removeAllActions()
        XCTAssertEqual(task.actionCount, 0)
    }

    static var allTests = [
        ("testAfter", testAfter),
        ("testRepeat", testRepeat),
        ("testTaskCenter", testTaskCenter),
        ("testDispatchQueue", testDispatchQueue),
        ("testThread", testThread),
        ("testExecuteNow", testExecuteNow),
        ("testReschedule", testReschedule),
        ("testSuspendResume", testSuspendResume),
        ("testCancel", testCancel),
        ("testAddAndRemoveActions", testAddAndRemoveActions)
    ]
}
