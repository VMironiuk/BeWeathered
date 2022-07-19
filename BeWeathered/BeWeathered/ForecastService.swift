//
//  ForecastService.swift
//  BeWeathered
//
//  Created by Volodymyr Myroniuk on 19.07.2022.
//

import Foundation

struct ForecastService: Decodable {
    let list: [ForecastList]?
}

struct ForecastList: Decodable {
    let dt: Int?
    let main: ForecastMain?
    let weather: [ForecastWeather]?
}

struct ForecastMain: Decodable {
    let temp_min: Double?
    let temp_max: Double?
}

struct ForecastWeather: Decodable {
    let main: String?
}
