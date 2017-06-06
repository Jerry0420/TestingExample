//
//  TestingExampleDataRequestTestsWithProtocol.swift
//  TestingExample
//
//  Created by JerryWang on 2017/5/17.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import XCTest
@testable import TestingExample

class TestingExampleDataRequestTestsWithProtocol: XCTestCase {
    
    var parseJsonManagerTest : ParseJsonManager?
    var apiManagerTest : APIManager?
    var searchMusicVCTest : SearchMusicViewController?
    let session = MockURLSession()
    
    
    override func setUp() {
        super.setUp()
        parseJsonManagerTest = ParseJsonManager()
        searchMusicVCTest = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchMusicVC") as! SearchMusicViewController)
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
        let url = APIManager.getQueryedURL(urlString: itunesURL, parameters: fakeParameters)
        //given
        weak var promiseInCallBack = expectation(description: "Status code: 200")
        
        //when
        XCTAssertEqual(searchMusicVCTest?.searchResults.count, 0, "searchResults should be empty before the data task runs")
        
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        apiManagerTest = APIManager(session: session)
        searchMusicVCTest?.apiManager = apiManagerTest
        searchMusicVCTest?.parseJsonManager = parseJsonManagerTest
        
        session.nextData = data
        session.nextError = nil
        session.nextResponse = urlResponse
        
        searchMusicVCTest?.getResultFrom(urlString: itunesURL, parameters: fakeParameters, completion: { (result) in
            
            if result == "Success"{
                guard let promise = promiseInCallBack else {
                    print("once was enough, thanks!")
                    return
                }
                
                promise.fulfill() //用於另一條thread中，要等待時間完成的
                promiseInCallBack = nil
            }
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //then
        XCTAssertEqual(searchMusicVCTest?.searchResults.count, 3, "Didn't parse 3 items from fake response")
    }
    
}
