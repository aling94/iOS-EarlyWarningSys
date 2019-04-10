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
let earthquakeURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_day.geojson"

class APIHandler : NSObject {
    override private init() {}
    
    static let shared = APIHandler()
    
    func fetchWeatherData(_ lat : Double, _ long : Double, completion : @escaping (WeatherResponse?) -> Void ) {
        let requestURL = String(format: weatherURL, lat, long)
        
        Alamofire.request(requestURL).responseObject { (response : DataResponse<WeatherResponse>) in
            let dsResponse = response.result.value
            completion(dsResponse)
        }
    }
    
    func fetchEQData(completion : @escaping ([Earthquake]?) -> Void ) {
        Alamofire.request(earthquakeURL).responseObject { (response : DataResponse<EarthquakeResponse>) in
            let dsResponse = response.result.value
            completion(dsResponse?.earthquakes)
        }
    }
}
