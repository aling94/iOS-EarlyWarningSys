//
//  APIHandler.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

let weatherURL = "https://api.darksky.net/forecast/1c32a0c10b1e247f0fc1f6ab8300b217/%d,%d"

class APIHandler : NSObject {
    override private init() {}
    
    static let shared = APIHandler()
    
    func fetchWeatherData(_ lat : Double, _ long : Double, completion : @escaping (DarkSkyResponse?) -> Void ) {
        let requestURL = String(format: weatherURL, lat, long)
        
        Alamofire.request(requestURL).responseObject { (response : DataResponse<DarkSkyResponse>) in
            let dsResponse = response.result.value
            completion(dsResponse)
        }
    }
    
}
