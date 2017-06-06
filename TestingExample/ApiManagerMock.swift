//
//  ApiManagerMock.swift
//  TestingExample
//
//  Created by JerryWang on 2017/5/14.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import Foundation

class ApiManagerMock : APIManager{
    
    var taskResponse: (Data?, URLResponse?, Error?)?
    
    convenience init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.init(session: URLSession.shared)
        taskResponse = (data, response, error)
    }
    
    override func requestWithURL(urlString: String, parameters: [String : Any]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let queryedURL = ApiManagerMock.getQueryedURL(urlString: urlString, parameters: parameters)
        
        let request = URLRequest(url: queryedURL)
        completion(taskResponse?.0, taskResponse?.1, taskResponse?.2)
        fetchedDataByDataTask(from: request, completion: completion)
    }
    
}


//測試
class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: NSError?
    
    fileprivate (set) var lastURL: URL?
    
    func dataTaskOfProtocol(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    fileprivate (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
