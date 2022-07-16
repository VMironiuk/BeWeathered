//
//  WeatherService.swift
//  BeWeathered
//
//  Created by Volodymyr Myroniuk on 15.07.2022.
//

import Foundation

struct WeatherService: Decodable {
    let name: String?
    let dt: Int?
    let main: WeatherServiceMain
    let weather: [WeatherServiceCondition]
}

struct WeatherServiceMain: Decodable {
    let temp: Double?
}

struct WeatherServiceCondition: Decodable {
    let main: String?
}
