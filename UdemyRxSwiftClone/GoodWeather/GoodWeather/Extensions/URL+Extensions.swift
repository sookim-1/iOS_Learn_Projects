//
//  URL+Extensions.swift
//  GoodWeather
//
//  Created by sookim on 10/24/23.
//

import Foundation

extension URL {
    
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=7d2dd8c9c5578b741c7735ad3f0d39ea&units=imperial")
    }
    
}
