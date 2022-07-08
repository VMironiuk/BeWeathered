//
//  WeatherViewController.swift
//  BeWeathered
//
//  Created by Volodymyr Myroniuk on 07.07.2022.
//

import Cocoa

class WeatherViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
    }
}

