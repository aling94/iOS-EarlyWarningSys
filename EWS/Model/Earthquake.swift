//
//  Earthquake.swift
//  EWS
//
//  Created by Alvin Ling on 4/10/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import ObjectMapper

class EarthquakeResponse: Mappable {
    var earthquakes: [Earthquake]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        earthquakes <- map["features"]
    }
}

class Earthquake: Mappable, CustomStringConvertible {
    var id, status, place: String?
    var mag: Double?
    var time : UInt64?
    var lat, long, depth: Double?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        
        status <- map["properties.status"]
        place <- map["properties.place"]
        mag <- map["properties.mag"]
        time <- map["properties.time"]
        
        long <- map["geometry.coordinates.0"]
        lat <- map["geometry.coordinates.1"]
        depth <- map["geometry.coordinates.2"]
    }
    
    var description: String {
        return "\(id!) - \(mag!) @ \(place!): (\(lat!), \(long!))"
    }
}
