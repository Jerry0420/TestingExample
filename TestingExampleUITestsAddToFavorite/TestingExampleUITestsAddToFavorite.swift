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
        
//        app.navigationBars["歌曲搜集"].buttons["Add"].tap()
//        let songNameOrArtistSearchField = app.searchFields["請輸入歌手或歌名......"]
//        songNameOrArtistSearchField.tap()
//
//        songNameOrArtistSearchField.typeText("Swift")
//        app.buttons["Search"].tap()
//
//        let cells = app.tables.cells
//        cells.element(boundBy: 0).tap()
//        
//        let exists = NSPredicate(format: "exists == true")
        
        
        //        let tablesQuery = app.tables
        //        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        //        let swiftStaticText = cell.staticTexts["Swift"]
        //        swiftStaticText.tap()
        //        cell.staticTexts["Pull Up"].tap()
        //        swiftStaticText.tap()
        //        cell.buttons["Download"].tap()
        //        tablesQuery.buttons["Pause"].tap()
        //        tablesQuery.buttons["Cancel"].tap()
    }
    
}
