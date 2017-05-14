//
//  SearchMusicViewController.swift
//  TestingExample
//
//  Created by JerryWang on 2017/5/13.
//  Copyright © 2017年 Jerrywang. All rights reserved.
//

import UIKit

class SearchMusicViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var apiManager : APIManager?
    
    var parseJsonManager : ParseJsonManager?
    
    let itunesURL = "https://itunes.apple.com/search?"
    
    var searchParameters : [String: String]?
    
    var searchResults = [Music]()
    
    var currentCount = 0
    
    var delegate : TotalCountDelegate?
    
    var userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager = APIManager()
        parseJsonManager = ParseJsonManager()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        setSearchBarForAccessibility()
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    func getResultFrom(urlString: String, parameters: [String: Any], completion: @escaping (String) -> Void){
        
        apiManager?.requestWithURL(urlString: urlString, parameters: parameters, completion: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200 {
                    
                    guard let data = data else{return}
                    
                    self.searchResults = [Music]()
                    
                    self.searchResults = (self.parseJsonManager?.updateSearchResults(data))!
                    
                    completion("Success")
                }
            }
        })
    }
    
    func increaseCurrentCount(){
        self.currentCount += 1
        self.userDefault.set(self.currentCount, forKey: "totalCount")
        self.userDefault.synchronize()
        self.delegate?.totalCount(currentCount: self.currentCount)
    }
    
}

extension SearchMusicViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !searchBar.text!.isEmpty {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let searchTerm = searchBar.text!
            
            searchParameters = ["media":"music","entity":"song","term":"\(searchTerm)"]
            
            getResultFrom(urlString: itunesURL, parameters: searchParameters!, completion: { result in
                
                if result == "Success"{
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.setCellForAccessibility()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            })
        }
    }
}

extension SearchMusicViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = searchResults[indexPath.row].name!
        cell.detailTextLabel?.text = searchResults[indexPath.row].singer!
        
        return cell
    }
    
}

extension SearchMusicViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let addAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "加入"){
            action,Index in
            
            action.backgroundColor = UIColor.gray
            
            self.increaseCurrentCount()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return [addAction]
    }
    
}

extension SearchMusicViewController{
    
    func setSearchBarForAccessibility(){
        searchBar.isAccessibilityElement = true
        searchBar.accessibilityTraits = UIAccessibilityTraitSearchField
        searchBar.accessibilityIdentifier = "請輸入歌手或歌名......"
    }
    
    func setCellForAccessibility(){
        tableView.isAccessibilityElement = true
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isAccessibilityElement = true
        tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.isAccessibilityElement = true
    }
}
