//
//  ViewController.swift
//  GithubQuery
//
//  Created by leafy on 2016/12/20.
//  Copyright © 2016年 leafy. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {
    
    fileprivate var tableView: UITableView?
    fileprivate var searchController: UISearchController?
    fileprivate var dataSource = [Repository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "GithubQuery"
        setupSearchController()
        setupTableView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController?.isActive = false
    }
    
    fileprivate func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        
        searchController?.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 64), style: .plain)
        tableView?.tableFooterView = UIView()
        tableView?.tableHeaderView = searchController?.searchBar
        //        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        view.addSubview(tableView!)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        HttpManager.manager.searchRepositoryData(by: searchText)
        HttpManager.manager.delegate = self
    }
}

extension ViewController: HttpManagerDelegate {
    func httpManager(returns searchResults: Array<Repository>) {
        dataSource = searchResults
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let repository = dataSource[indexPath.row]
        cell?.textLabel?.text = repository.owner
        cell?.detailTextLabel?.text = repository.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryVC = RepositoryViewController()
        repositoryVC.repository = dataSource[indexPath.row]
        navigationController?.pushViewController(repositoryVC, animated: true)
    }
}

