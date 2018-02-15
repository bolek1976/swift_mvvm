//
//  ViewModel.swift
//  MVVM
//
//  Created by Boris Chirino Fernandez on 06/02/2018.
//  Copyright © 2018 SmartSeed. All rights reserved.
//

import Foundation


class ViewModel :NSObject {
    var apps : [NSDictionary] = [NSDictionary]()
    private var API : ItunesAPIClient
    @objc dynamic var isBusy : Bool =  false
    
    
    // this constructor claims that his only parameter must conform to ItunesAPIClient
    init<T : ItunesAPIClient>(restAPI : T ) {
        API = restAPI
    }
    
    
    func getApps( completion :@escaping ()->Void) {
        self.isBusy = true
        API.topFreeGames { (appsArray) in
            DispatchQueue.main.sync {
                if let result = appsArray {
                    self.apps =  result
                }
                self.isBusy = false
                completion()
            }
        }
    }
    
    
    func appTitle(indexPath : IndexPath) -> String {
        if apps.count >= 1 {
            return apps[indexPath.row].value(forKey: "name") as! String
        }else {
            return ""
        }
    }
    
    
    func appCopyright(indexPath : IndexPath) -> String {
        if apps.count >= 1 {
            return apps[indexPath.row].value(forKey: "copyright") as! String
        }else {
            return ""
        }
    }
}
