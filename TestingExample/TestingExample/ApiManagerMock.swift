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
        self.init()
        taskResponse = (data, response, error)
    }
    
    override func requestWithURL(urlString: String, parameters: [String : Any], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = []
        
        for (key, value) in parameters{
            guard let value = value as? String else{return}
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        guard let queryedURL = urlComponents.url else{return}
        
        let request = URLRequest(url: queryedURL)
        completion(taskResponse?.0, taskResponse?.1, taskResponse?.2)
        fetchedDataByDataTask(from: request, completion: completion)
    }
}
