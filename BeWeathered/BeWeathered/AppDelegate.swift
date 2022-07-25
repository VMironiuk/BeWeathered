//
//  AppDelegate.swift
//  BeWeathered
//
//  Created by Volodymyr Myroniuk on 07.07.2022.
//

import Cocoa
import CoreLocation

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let weatherLoader = WeatherLoader(client: HTTPClient())
    private let locationManager = CLLocationManager()
    private var location: Location?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "--°"
        statusItem.button?.action = #selector(onStatusItemButtonPressed)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @objc private func onStatusItemButtonPressed() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let weatherVC = storyboard.instantiateController(
            withIdentifier: "WeatherViewController") as! WeatherViewController
        weatherVC.weatherLoader = makeWeatherLoader()
        weatherVC.location = location
        
        let popover = NSPopover()
        popover.contentViewController = weatherVC
        popover.behavior = .transient
        popover.show(
            relativeTo: statusItem.button!.bounds,
            of: statusItem.button!,
            preferredEdge: .maxY)
    }
    
    private func makeWeatherLoader() -> WeatherLoader {
        WeatherLoader(client: HTTPClient())
    }

}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        location = Location(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude)
        
        weatherLoader.loadWeather(for: location!) { [weak self] weather in
            DispatchQueue.main.async {
                self?.statusItem.button?.title = weather.temperature
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
