//
//  AppDelegate.swift
//  BeWeathered
//
//  Created by Volodymyr Myroniuk on 07.07.2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let weatherLoader = WeatherLoader(client: HTTPClient())

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "--°"
        statusItem.button?.action = #selector(onStatusItemButtonPressed)
        
        weatherLoader.load { [weak self] weather in
            DispatchQueue.main.async {
                self?.statusItem.button?.title = weather.temperature
            }
        }
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @objc private func onStatusItemButtonPressed() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let weatherVC = storyboard.instantiateController(
            withIdentifier: "WeatherViewController") as! WeatherViewController
        weatherVC.weatherLoader = makeWeatherLoader()
        
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

