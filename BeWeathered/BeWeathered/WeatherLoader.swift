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
    
    func load() {
        let url = URL(string: "https://some-url")!
        client.get(from: url) { data, response, error in
            print(String(data: data!, encoding: .utf8) ?? "")
        }
    }
}
