//
//  TestingExampleUITestsAddToFavorite.swift
//  TestingExampleUITestsAddToFavorite
//
//  Created by JerryWang on 2017/5/14.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import XCTest

class TestingExampleUITestsAddToFavorite: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
    
    func testDataRequest() {
        
        app.navigationBars["歌曲搜集"].buttons["Add"].tap()
        let textfieldNavigationBar = app.navigationBars["textField"]
        let textfieldTextField = textfieldNavigationBar.textFields["textField"]
        textfieldTextField.tap()
        textfieldTextField.typeText("beatles")
        
        let tablesQuery = app.tables
        let cell = tablesQuery.cells.staticTexts["Here Comes the Sun"]
        
        let exist = NSPredicate(format: "exists == true")
        expectation(for: exist, evaluatedWith: cell, handler: nil)
        
        app.keyboards.buttons["return"].tap()
        
        waitForExpectations(timeout: 8, handler: nil)
        
        XCTAssert(cell.exists, "We didn't get the data!")
    
    }
    
}
