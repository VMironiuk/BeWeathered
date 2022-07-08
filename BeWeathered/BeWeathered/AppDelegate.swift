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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "--°"
        statusItem.button?.action = #selector(onStatusItemButtonPressed)
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @objc private func onStatusItemButtonPressed() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let weatherVC = storyboard.instantiateController(
            withIdentifier: "WeatherViewController") as! NSViewController
        
        let popover = NSPopover()
        popover.contentViewController = weatherVC
        popover.behavior = .transient
        popover.show(
            relativeTo: statusItem.button!.bounds,
            of: statusItem.button!,
            preferredEdge: .maxY)
    }

}

