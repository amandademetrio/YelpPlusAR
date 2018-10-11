//
//  YelpPlusARModel.swift
//  YelpPlusAR
//
//  Created by Amanda Demetrio on 10/11/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import Foundation

class YelpPlusARModel {
    // Note that we are passing in a function to the getAllPeople method (similar to our use of callbacks in JS). This function will allow the ViewController that calls this method to dictate what runs upon completion.
    static func getAllFood(completionHandler:@escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void, _ userLat: Double, _ userLong: Double) {
        let token = "OVZY9-01RSLTvs5AFJsT2qkjlzU4fpAluVPlMeXu5rjSjgOz24ZDGbiW9vRMCN_Cffw2ZIQQ8G97OaJtQL4YHieVumR_rSJk3gg0eQcbrocj05Ye3Yq9IsL5g4mhW3Yx"

        let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=restaurants&latitude=\(userLat)&longitude=\(userLong)")

        let session = URLSession.shared
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        
        task.resume()
    }
}
