//
//  APIManager.swift
//  HTTPExample
//
//  Created by JerryWang on 2017/2/28.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import Foundation

class APIManager{
    
    func requestWithURL(urlString: String, parameters: [String: Any], completion: @escaping (Data?, URLResponse?, Error?) -> Void){
        
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = []
        
        for (key, value) in parameters{
            guard let value = value as? String else{return}
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        guard let queryedURL = urlComponents.url else{return}
        
        let request = URLRequest(url: queryedURL)
        
        fetchedDataByDataTask(from: request, completion: completion)
    }
    
    func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            completion(data, response, error)
        }
        task.resume()
    }
    
}

