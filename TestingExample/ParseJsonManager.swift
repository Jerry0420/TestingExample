//
//  ParseJsonManager.swift
//  TestingExample
//
//  Created by JerryWang on 2017/5/13.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import Foundation

class ParseJsonManager{
    
    func updateSearchResults(_ data: Data?) -> [Music]? {
        
        var parsedResult = [Music]()
        
        do {
            if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                
                if let array: AnyObject = response["results"] {
                    for musicDictonary in array as! [AnyObject] {
                        if let musicDictonary = musicDictonary as? [String: AnyObject] {
                            
                            let name = musicDictonary["trackName"] as? String
                            let singer = musicDictonary["artistName"] as? String
                            
                            parsedResult.append(Music(name: name, singer: singer))
                            
                        } else {
                            print("Not a dictionary")
                        }
                    }
                } else {
                    print("Results key not found in dictionary")
                }
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        
        return parsedResult
    }
}
