//
//  APIManager.swift
//  HTTPExample
//
//  Created by JerryWang on 2017/2/28.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import Foundation

class APIManager{
    
    fileprivate let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    static func getQueryedURL(urlString: String, parameters: [String: Any]?) -> URL{
        
        var url : URL!
        
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = []
        
        if let parameters = parameters{
            for (key, value) in parameters{
                if let value = value as? String{
                    urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
                }
            }
        }
        if let queryedURL = urlComponents.url{
            url = queryedURL
        }
        
        return url
    }
    
    func requestWithURL(urlString: String, parameters: [String: Any]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void){
        
        let queryedURL = APIManager.getQueryedURL(urlString: urlString, parameters: parameters)
        
        let request = URLRequest(url: queryedURL)
        
        fetchedDataByDataTask(from: request, completion: completion)
    }
    
    func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void){
        
        let task = session.dataTaskOfProtocol(with: request) { (realData, response, error) in
            //            let fakeData = self.fetchFakeData()
            //            let data = self.UITesting() ? fakeData: realData
            
            var data = realData
            
            if self.UITesting(){
                data = self.fetchFakeData()
            }
            
            completion(data, response, error)
        }
        task.resume()
        
    }
    
    private func UITesting() -> Bool {
        
        if let environmentString = ProcessInfo.processInfo.environment["For UI-TEST"]{
        
            print(environmentString)
        }
        
        return ProcessInfo.processInfo.arguments.contains("UI-TESTING")
    }
    
    private func fetchFakeData() -> Data?{
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "abbaData", ofType: "json")
        let fakeData = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        return fakeData
    }
    
}
