//
//  Weather.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import ObjectMapper
import Foundation

class DarkSkyResponse : Mappable {
    
    var latitude, longitude : Double?
    var currentTemp, high, low : Double?
    var timezone : String?
    var currently : CurrentForecast?
    var daily : [DailyForecast]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        timezone <- map["timezone"]
        currently <- map["currently"]
        daily <- map["daily.data"]
        high <- map["daily.data.0.temperatureHigh"]
        low <- map["daily.data.0.temperatureLow"]
        currentTemp <- map["currently.temperature"]
    }
    
    var date : String? {
        let time = (currently?.time)!
        //        return formatDate(time: time, format: "MMMM dd, yyyy")
        return formatWeekday(time: time)
    }
}


class CurrentForecast : Mappable {
    
    var time : UInt64?
    var temp : Double?
    var icon : String?
    var summary : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        time <- map["time"]
        temp <- map["temperature"]
        icon <- map["icon"]
        summary <- map["summary"]
    }
}

class DailyForecast : Mappable {
    
    var time : UInt64?
    var high, low : Double?
    var icon : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        time <- map["time"]
        high <- map["temperatureHigh"]
        low <- map["temperatureLow"]
        icon <- map["icon"]
    }
    
    var date : String? {
        return formatDate(time: time!, format: "MMMM dd, yyyy")
    }
}

func formatDate(time : UInt64, format : String) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    let interval = TimeInterval(exactly: time)!
    let date = Date.init(timeIntervalSince1970: interval)
    return formatter.string(from: date)
}

func formatWeekday(time : UInt64) -> String? {
    let formatter = DateFormatter()
    let interval = TimeInterval(exactly: time)!
    let date = Date.init(timeIntervalSince1970: interval)
    let weekday = formatter.weekdaySymbols[Calendar.current.component(.weekday, from: date)]
    return weekday.capitalized
}
