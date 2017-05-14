//
//  TestingExampleTableViewTests.swift
//  TestingExampleTableViewTests
//
//  Created by JerryWang on 2017/5/14.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import XCTest
@testable import TestingExample

class TestingExampleTableViewTests: XCTestCase {
    
    var parseJsonManagerTest : ParseJsonManager?
    var apiManagerTest : APIManager?
    var searchMusicVCTest : SearchMusicViewController?
    var tableView: UITableView?
    let itunesURL = "https://itunes.apple.com/search?"
    let fakeParameters = ["fake":"url"]
    
    override func setUp() {
        super.setUp()
        parseJsonManagerTest = ParseJsonManager()
        searchMusicVCTest = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchMusicVC") as! SearchMusicViewController)
        tableView = UITableView()
        searchMusicVCTest?.tableView = tableView
        searchMusicVCTest?.tableView.dataSource = searchMusicVCTest
        searchMusicVCTest?.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "abbaData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        //when
        XCTAssertEqual(searchMusicVCTest?.searchResults.count, 0, "searchResults should be empty before the data task runs")
        
        let url = URL(string: "https://itunes.apple.com/search?fake=url")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        apiManagerTest = ApiManagerMock(data: data, response: urlResponse, error: nil)
        
        searchMusicVCTest?.apiManager = apiManagerTest
        searchMusicVCTest?.parseJsonManager = parseJsonManagerTest
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        parseJsonManagerTest = nil
        apiManagerTest = nil
        searchMusicVCTest = nil
        tableView = nil
        super.tearDown()
    }
    
    func testNumberOfRows() {
        
        weak var promiseInCallBack = expectation(description: "Status code: 200")
        
        searchMusicVCTest?.getResultFrom(urlString: itunesURL, parameters: fakeParameters, completion: { (result) in
            
            if result == "Success"{
                
                self.searchMusicVCTest?.tableView.reloadData()
                
                guard let promise = promiseInCallBack else {
                    print("once was enough, thanks!")
                    return
                }
                
                promise.fulfill()
                promiseInCallBack = nil
            }
        })
        
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(searchMusicVCTest?.tableView.dataSource?.tableView((searchMusicVCTest?.tableView)!, numberOfRowsInSection: 0), 3, "After adding one person number of sections should be 1")
    }
    
    func testTextInCell() {
        
        var cell : UITableViewCell?
        
        weak var promiseInCallBack = expectation(description: "Status code: 200")
        
        searchMusicVCTest?.getResultFrom(urlString: itunesURL, parameters: fakeParameters, completion: { (result) in
            
            if result == "Success"{
                
                self.searchMusicVCTest?.tableView.reloadData()
                cell = self.searchMusicVCTest?.tableView.dataSource?.tableView((self.searchMusicVCTest?.tableView)!, cellForRowAt: IndexPath(row: 0, section: 0))
                guard let promise = promiseInCallBack else {
                    print("once was enough, thanks!")
                    return
                }
                
                promise.fulfill()
                promiseInCallBack = nil
                
            }
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(cell?.textLabel!.text!, "Dancing Queen", "Full name is not as expected")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
