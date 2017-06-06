//
//  TestingExampleWithProtocol.swift
//  TestingExample
//
//  Created by JerryWang on 2017/5/17.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import XCTest
@testable import TestingExample
class TestingExampleWithProtocol: XCTestCase {
    
    var subject: APIManager?
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        
        subject = APIManager(session: session)
    }
    
    override func tearDown() {
        
        subject = nil
        
        super.tearDown()
    }

    //Test the URL
    //create a mock session and inject it into the subject under test. Then we call the stimulus, get(), with a referenced URL. Finally, we assert that the URL the session received was the same one we passed in.
    //從apimanager傳進去的，可以在mock class內接收到
    func testGETRequestsTheURL() {
        let itunesURL = "https://itunes.apple.com/search?"
        
        subject?.requestWithURL(urlString: itunesURL, parameters: nil, completion: { (data, response, error) in
            
        })
        
        XCTAssert(session.lastURL?.absoluteString == itunesURL)
    }
    //create a reference to our mock data task and assign it to the session. After calling the stimulus, we assert that the resumeWasCalled flag was set on the data task.
    //Test that resume() Was Called
    func testGETStartsTheRequest() {
        let itunesURL = "https://itunes.apple.com/search?"
        
        let dataTask = MockURLSessionDataTask()
        
        session.nextDataTask = dataTask
        
        subject?.requestWithURL(urlString: itunesURL, parameters: nil, completion: { (data, response, error) in
            
        })
        
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func test_GET_WithResponseData_AndA200StatusCode_ReturnsTheData() {
        let expectedData = "{}".data(using: String.Encoding.utf8)
        session.nextData = expectedData!
        
        let itunesURL = "https://itunes.apple.com/search?"
        
        session.nextResponse = HTTPURLResponse(url: URL(string: itunesURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        var actualData: Data?
        
        subject?.requestWithURL(urlString: itunesURL, parameters: nil, completion: { (data, response, error) in
            actualData = data
        })
        
        XCTAssertEqual(actualData, expectedData)
    }
    
    func test_GET_WithANetworkError_ReturnsANetworkError() {
        
        session.nextError = NSError(domain: "error", code: 0, userInfo: nil)
        
        var error: Error?
        
        let itunesURL = "https://itunes.apple.com/search?"
        
        subject?.requestWithURL(urlString: itunesURL, parameters: nil, completion: { (data, response, theError) in
            
            error = theError
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_GET_WithResponseDataAndANetworkError_ReturnsAnError() {
        
        session.nextData = "{}".data(using: String.Encoding.utf8)!
        session.nextError = NSError(domain: "error", code: 0, userInfo: nil)
        
        var error: Error?
        
        let itunesURL = "https://itunes.apple.com/search?"
        
        subject?.requestWithURL(urlString: itunesURL, parameters: nil, completion: { (data, response, theError) in
            error = theError
        })
        
        XCTAssertNotNil(error)
    }
    
    func test_GET_WithAStatusCodeLessThan200_ReturnsAnError() {
        
        let itunesURL = "https://itunes.apple.com/search?"
        
        session.nextResponse = HTTPURLResponse(url: URL(string: itunesURL)!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        var error: Error?
        
        subject?.requestWithURL(urlString: itunesURL, parameters: nil, completion: { (data, response, theError) in
            XCTAssertNil(data)
            error = theError
        })
        
        XCTAssertNil(error)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
