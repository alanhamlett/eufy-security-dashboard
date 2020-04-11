//
//  LorikeetTests.swift
//  LorikeetTests
//
//  Created by Þorvaldur Rúnarsson on 27/10/2017.
//  Copyright © 2017 Thorvaldur. All rights reserved.
//

import XCTest
@testable import Lorikeet

class LorikeetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAlgorithm() {
        let red: UIColor = .red
        let green: UIColor = .green
        let blue: UIColor = .blue

        var diff = abs(red.lkt.distance(to: red, algorithm: .cie2000))
        XCTAssert(diff == 0)
        
        diff = abs(green.lkt.distance(to: green, algorithm: .cie2000))
        XCTAssert(diff == 0)
        
        diff = abs(blue.lkt.distance(to: blue, algorithm: .cie2000))
        XCTAssert(diff == 0)
        
        diff = red.lkt.distance(to: green, algorithm: .cie2000)
        XCTAssert(diff > 0)
        
        diff = red.lkt.distance(to: blue, algorithm: .cie2000)
        XCTAssert(diff > 0)
        
        diff = green.lkt.distance(to: blue, algorithm: .cie2000)
        XCTAssert(diff > 0)
        
    }
}
