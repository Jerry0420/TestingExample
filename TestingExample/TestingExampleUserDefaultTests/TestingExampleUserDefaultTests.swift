//
//  TestingExampleUserDefaultTests.swift
//  TestingExampleUserDefaultTests
//
//  Created by JerryWang on 2017/5/14.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import XCTest
@testable import TestingExample

class TestingExampleUserDefaultTests: XCTestCase {
    
    var searchMusicVCTest : SearchMusicViewController?
    var totalCountVCTest : TotalCountViewController?
    var mockUserDefaults: MockUserDefaults?
    
    override func setUp() {
        super.setUp()
        
        searchMusicVCTest = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchMusicVC") as! SearchMusicViewController)
        totalCountVCTest = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "totalCountVC") as! TotalCountViewController)
        mockUserDefaults = MockUserDefaults(suiteName: "testing")

        searchMusicVCTest?.userDefault = mockUserDefaults!
        searchMusicVCTest?.delegate = totalCountVCTest
        totalCountVCTest?.userDefault = mockUserDefaults!
    }
    
    override func tearDown() {
        searchMusicVCTest = nil
        totalCountVCTest = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    func testUserDefaultsSet(){
        
        searchMusicVCTest?.currentCount = 2
        searchMusicVCTest?.increaseCurrentCount()
        XCTAssertTrue((mockUserDefaults?.totalCountAfterChanged)!, "totalCount user default wasn't changed")
    }
    
    func testTotalCountAndCurrentCount(){
        searchMusicVCTest?.currentCount = 2
        searchMusicVCTest?.increaseCurrentCount()
        XCTAssertEqual(searchMusicVCTest?.currentCount, 3, "totalCount user default wasn't changed")
        XCTAssertEqual(totalCountVCTest!.totalCount, 3, "totalCount user default wasn't changed")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class MockUserDefaults: UserDefaults {
    
    var totalCountAfterChanged = false
    
    override func set(_ value: Int, forKey defaultName: String) {
        if defaultName == "totalCount"{
            totalCountAfterChanged = true
        }
    }

}
