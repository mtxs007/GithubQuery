
//
//  HttpManager.swift
//  GithubQuery
//
//  Created by leafy on 2016/12/21.
//  Copyright © 2016年 leafy. All rights reserved.
//

import UIKit

protocol HttpManagerDelegate {
    func httpManager(returns searchResults: Array<Repository>)
}

class HttpManager {
    
    static let manager = HttpManager()
    public var delegate: HttpManagerDelegate?
    
    private init() { }
    
    func searchRepositoryData(by keywords: String) {
        var results = [Repository]()
        let urlString = "https://api.github.com/search/repositories?q=" + keywords
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let `error` = error {
                print(error.localizedDescription)
            } else {
                if let `data` = data {
                    let dataJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    if let `dataJson` = dataJson {
                        if let items = dataJson["items"] as? Array<Any> {
                            for item in items  {
                                let dict = item as! Dictionary<String, Any>
                                var respository = Repository()
                                respository.name = dict["name"] as? String
                                respository.owner = (dict["owner"] as! Dictionary<String, Any>)["login"] as? String
                                respository.html_url = dict["html_url"] as? String
                                results.append(respository)
                            }
                        }
                        self.delegate?.httpManager(returns: results)
                    }
                } else {
                    print("data is nil")
                }
            }
        }
        dataTask.resume()
    }
}
