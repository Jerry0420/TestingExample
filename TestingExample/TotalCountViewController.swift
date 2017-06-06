//
//  ViewController.swift
//  TestingExample
//
//  Created by JerryWang on 2017/5/12.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import UIKit

protocol TotalCountDelegate {
    func totalCount(currentCount: Int)
}

class TotalCountViewController: UIViewController, TotalCountDelegate {
    
    @IBOutlet weak var totalCountsLabel: UILabel!
    
    @IBOutlet weak var clearSavedMusicButton: UIButton!
    
    @IBOutlet weak var showDetailsButton: UIButton!
    
    var userDefault = UserDefaults.standard
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let totalCount = userDefault.object(forKey: "totalCount") as? Int{
            self.totalCount = totalCount
        }
        
        totalCountsLabel.text = "\(totalCount)首歌"
        clearSavedMusicButton.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        showDetailsButton.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.totalCountsLabel.text = "\(self.totalCount)首歌"
    }
    
    func totalCount(currentCount: Int) {
        
        self.totalCount = currentCount
        self.userDefault.set(totalCount, forKey: "totalCount")
        self.userDefault.synchronize()
    }
    
    func clearAll(){
        userDefault.removeObject(forKey: "totalCount")
        self.totalCount = 0
        totalCountsLabel.text = "\(self.totalCount)首歌"
    }
    
    func showDetails(){
        let alert = UIAlertController(title: nil, message: "點選右上角的加號，即可新增歌曲。", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got It!", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func goToSearchMusicsVC(_ sender: UIBarButtonItem) {
        
        let searchMusicVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchMusicVC") as! SearchMusicViewController
        
        searchMusicVC.currentCount = totalCount
        searchMusicVC.delegate = self
        
        present(searchMusicVC, animated: true, completion: nil)
        
        
    }
    
}

