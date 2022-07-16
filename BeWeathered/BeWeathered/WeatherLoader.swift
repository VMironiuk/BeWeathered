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
    
    func load(completion: @escaping (Weather) -> Void) {
        let url = URL(string: "https://some-url.com")!
        client.get(from: url) { data, response, error in
            let decoder = JSONDecoder()
            let weatherService = try! decoder.decode(WeatherService.self, from: data!)
            completion(Weather(service: weatherService))
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
