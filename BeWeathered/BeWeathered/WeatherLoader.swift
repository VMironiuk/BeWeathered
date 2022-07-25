//
//  WeatherLoader.swift
//  BeWeathered
//
//  Created by Volodymyr Myroniuk on 12.07.2022.
//

import Foundation

final class HTTPClient {
    func get(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
}

final class WeatherLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadWeather(for location: Location, completion: @escaping (Weather) -> Void) {
        let url = URL(string: "https://some-url.com")!
        client.get(from: url) { data, response, error in
            let decoder = JSONDecoder()
            let weatherService = try! decoder.decode(WeatherService.self, from: data!)
            completion(Weather(service: weatherService))
        }
    }
    
    func loadForecast(for location: Location, completion: @escaping ([Forecast]) -> Void) {
        let url = URL(string: "https://some-url.com")!
        client.get(from: url) { data, response, error in
            let decoder = JSONDecoder()
            let forecastService = try! decoder.decode(ForecastService.self, from: data!)
            guard let forecastList = forecastService.list else { return { completion([]) }() }
            completion(forecastList.compactMap {Forecast(forecastList: $0)})
        }
    }
}

private extension Weather {
    init(service: WeatherService) {
        cityName = service.name ?? "--"
        
        if let temp = service.main.temp {
            temperature = "\(Int(temp))°"
        }
        else {
            temperature = "--°"
        }
        
        if let main = service.weather.first?.main {
            condition = main
        }
        else {
            condition = "--"
        }
        
        if let dt = service.dt {
            let currentDate = Date(timeIntervalSince1970: Double(dt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .none
            dateFormatter.timeZone = .current
            date = dateFormatter.string(from: currentDate)
        }
        else {
            date = "Today --"
        }
    }
}

private extension Forecast {
    init(forecastList: ForecastList) {
        if let main = forecastList.weather?.first?.main {
            condition = main
        }
        else {
            condition = "--"
        }
        
        if let temp_min = forecastList.main?.temp_min {
            minTemperature = "\(temp_min)°"
        }
        else {
            minTemperature = "--°"
        }
        
        if let temp_max = forecastList.main?.temp_max {
            maxTemperature = "\(temp_max)°"
        }
        else {
            maxTemperature = "--°"
        }
        
        if let dt = forecastList.dt {
            let currentDate = Date(timeIntervalSince1970: Double(dt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            dateFormatter.timeZone = .current
            date = dateFormatter.string(from: currentDate)
        }
        else {
            date = "--"
        }
    }
}
