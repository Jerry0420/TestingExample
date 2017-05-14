//
//  TestingExampleDataRequestTests.swift
//  TestingExampleDataRequestTests
//
//  Created by JerryWang on 2017/5/13.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import XCTest
@testable import TestingExample

class TestingExampleDataRequestTests: XCTestCase {
    
    var parseJsonManagerTest : ParseJsonManager?
    var apiManagerTest : APIManager?
    var searchMusicVCTest : SearchMusicViewController?
    
    override func setUp() {
        super.setUp()
        parseJsonManagerTest = ParseJsonManager()
        searchMusicVCTest = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchMusicVC") as! SearchMusicViewController)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        parseJsonManagerTest = nil
        apiManagerTest = nil
        searchMusicVCTest = nil
        super.tearDown()
    }
    
    func testApiManagerToParseJsonData() {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "abbaData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        let itunesURL = "https://itunes.apple.com/search?"
        let fakeParameters = ["fake":"url"]
        
        //given
        weak var promiseInCallBack = expectation(description: "Status code: 200")
        
        //when
        XCTAssertEqual(searchMusicVCTest?.searchResults.count, 0, "searchResults should be empty before the data task runs")
        
        let url = URL(string: "https://itunes.apple.com/search?fake=url")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        apiManagerTest = ApiManagerMock(data: data, response: urlResponse, error: nil)
        searchMusicVCTest?.apiManager = apiManagerTest
        searchMusicVCTest?.parseJsonManager = parseJsonManagerTest
        
        searchMusicVCTest?.getResultFrom(urlString: itunesURL, parameters: fakeParameters, completion: { (result) in
            
            if result == "Success"{
                guard let promise = promiseInCallBack else {
                    print("once was enough, thanks!")
                    return
                }
                
                promise.fulfill()
                promiseInCallBack = nil
            }
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //then
        XCTAssertEqual(searchMusicVCTest?.searchResults.count, 3, "Didn't parse 3 items from fake response")
    }
    
    func testParseJsonData(){
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "abbaData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        var parsedResult = [Music]()
        
        if let data = data{
            parsedResult = (self.parseJsonManagerTest?.updateSearchResults(data))!
        }
        
        XCTAssertEqual(parsedResult.count, 3, "Didn't parse 3 items from fake response")
    }
    
    func testValidRequestWithData(){
        
        let itunesURL = "https://itunes.apple.com/search?"
        let searchParameters = ["media":"music","entity":"song","term":"taylor swift"]
        weak var promiseInCallBack = expectation(description: "Status code: 200")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        apiManagerTest = APIManager()
        apiManagerTest?.requestWithURL(urlString: itunesURL, parameters: searchParameters, completion: { (data, response, error) in
            
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            
            guard let promise = promiseInCallBack else {
                print("once was enough, thanks!")
                return
            }
            
            promise.fulfill()
            promiseInCallBack = nil
            
            
            //            //then
            //            if let error = error {
            //
            //                XCTFail("Error: \(error.localizedDescription)")
            //                return
            //            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            //                if statusCode == 200 {
            //                    promise.fulfill()
            //                } else {
            //                    XCTFail("Status code: \(statusCode)")
            //                }
            //            }
            
        })
        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

