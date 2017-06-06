//
//  TestingExampleUITestsWithFakeData.swift
//  TestingExample
//
//  Created by JerryWang on 2017/5/16.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import XCTest

class TestingExampleUITestsWithFakeData: XCTestCase {
        
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["UI-TESTING"]
        app.launchEnvironment["For UI-TEST"] = "Hello World~"
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
    
    func testClearAll(){
        
        increaseOneCountWithFakeData()
        
        app.buttons["清除"].tap()
        let label = app.staticTexts["0首歌"]
        
        XCTAssert(label.exists, "Not successfully clear all")
    }
    
    func testIncreaseTotalCounts(){
        app.buttons["清除"].tap()
        
        increaseOneCountWithFakeData()
        
        let label = app.staticTexts["1首歌"]
        XCTAssert(label.exists, "Not successfully increase total counts")
    }
    
    func testShowAlert(){
        
        app.buttons["More Info"].tap()
        
        addUIInterruptionMonitor(withDescription: "") { (alert) -> Bool in
            alert.buttons["Got It!"].tap()
            
            return true
        }
        
    }
    
    func increaseOneCountWithFakeData(){
        
//        let searchBar = app.searchFields.element
        
        app.navigationBars["歌曲搜集"].buttons["Add"].tap()
        let textfieldNavigationBar = app.navigationBars["textField"]
        let textfieldTextField = textfieldNavigationBar.textFields["textField"]
        textfieldTextField.tap()
        textfieldTextField.typeText("fakeData")
        app.keyboards.buttons["return"].tap()
        sleep(3)
        let tablesQuery = app.tables //Here Comes the Sun
        let cell = tablesQuery.cells.staticTexts["Dancing Queen"]
        
        cell.swipeLeft()
        app.buttons["加入"].tap()
        textfieldNavigationBar.buttons["Back"].tap()
    }
    
}
