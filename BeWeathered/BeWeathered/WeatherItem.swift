//
//  WeatherItem.swift
//  BeWeathered
//
//  Created by Volodymyr Myroniuk on 10.07.2022.
//

import Cocoa

class WeatherItem: NSCollectionViewItem {

    @IBOutlet private weak var dateLabel: NSTextField!
    @IBOutlet private weak var minimumTemperatureLabel: NSTextField!
    @IBOutlet private weak var maximumTemperatureLabel: NSTextField!
    @IBOutlet private weak var conditionImageView: NSImageView!
    
    func configure(with forecast: Forecast) {
        dateLabel.stringValue = forecast.date
        minimumTemperatureLabel.stringValue = forecast.minTemperature
        maximumTemperatureLabel.stringValue = forecast.maxTemperature
        conditionImageView.image = NSImage(named: forecast.condition)
    }
}
