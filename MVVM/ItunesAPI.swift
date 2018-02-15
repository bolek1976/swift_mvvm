//
//  ItunesAPI.swift
//  MVVM
//
//  Created by Boris Chirino Fernandez on 06/02/2018.
//  Copyright © 2018 SmartSeed. All rights reserved.
//

import Foundation

// one of the main S.O.L.I.D aproach. Interface segregation.
// be water my friend...
protocol ItunesAPIClient {
    func topFreeGames(result : @escaping ([NSDictionary]?)-> Void) -> Void
}


class ItunesAPI : NSObject, ItunesAPIClient {
    
    // endpoint from with gather data. if this url does not work make one yourself here
    // https://rss.itunes.apple.com/en-us
    // configure how data will ve served, min config :
    // Media Type :iOS Apps,
    // Feed Type : Top Free
    // Format : JSON
    fileprivate let baseURL = URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/10/explicit.json")

    // private singleton for this class, used by statics methods
    fileprivate static let shared : ItunesAPI = ItunesAPI()
    
    // network session
    fileprivate let session: URLSession
    
    override init () {
        //let config :URLSessionConfiguration = URLSessionConfiguration.default
        session = URLSession.shared
    }
    
    
    
    
    
  /// Retrieve top 10 free games from itunes feed . -> instance method.
  ///
  /// - Parameter result: An array of elements containing App data
  @objc func topFreeGames(result : @escaping ([NSDictionary]?)-> Void) {
    
    // create session task
    let dataTask = session.dataTask(with: baseURL!) { (data, response, error) in
    
    // evident, right ?
            guard error == nil else {
                print("An error ocurred during https com.. :\n \(String(describing: error!.localizedDescription))")
                result(nil)
                return
            }
    //get response and try to parse results. Invoque closures
            do{
                let fullResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                
                if let apps = fullResponse?.value(forKeyPath: "feed.results") as? [NSDictionary] {
                    result(apps)
                }else {
                    result(nil)
                }
            }catch (let error) {
                print("error parsing response ..: \n \(error.localizedDescription)")
            }
        }
    
     //fire up communications
        dataTask.resume()
    }
    
    
    
    
    /// Same as previous in funcitonallity but different in implementation. This is a class function or static function depending of school
    ///
    /// - Parameter result: An array of elements containing App data
    static func topFreeGames(result : @escaping ([NSDictionary]?)-> Void) {
        
        let apiInstance = ItunesAPI.shared
        
       let dataTask = apiInstance.session.dataTask(with: apiInstance.baseURL!) { (data, response, error) in
            
            do{
                let j = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                if let apps = j?.value(forKeyPath: "feed.results") as? [NSDictionary] {
                    result(apps)
                }else {
                    result(nil)
                }
            }catch (let error) {
                print("error parsing response .. \(error.localizedDescription)")
            }
        }
        
        dataTask.resume()
    }
}
