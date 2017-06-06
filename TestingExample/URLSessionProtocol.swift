//
//  URLSessionProtocol.swift
//  TestingExample
//
//  Created by JerryWang on 2017/5/17.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol{
    
}

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTaskOfProtocol(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTaskProtocol
}

extension URLSession : URLSessionProtocol{
    
    func dataTaskOfProtocol(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        var urlSessionDataTaskProtocol : URLSessionDataTaskProtocol
        
        urlSessionDataTaskProtocol = dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
        
        return urlSessionDataTaskProtocol
    }
    
}
