//
//  WeatherViewController.swift
//  BeWeathered
//
//  Created by Volodymyr Myroniuk on 07.07.2022.
//

import Cocoa
import CoreLocation

class WeatherViewController: NSViewController {

    @IBOutlet private weak var currentDateLable: NSTextField!
    @IBOutlet private weak var temperatureLabel: NSTextField!
    @IBOutlet private weak var locationLabel: NSTextField!
    @IBOutlet private weak var weatherConditionImageView: NSImageView!
    @IBOutlet private weak var weatherConditionLabel: NSTextField!
    @IBOutlet private weak var collectionView: NSCollectionView!
    
    private var forecast: [Forecast] = []
    
    var weatherLoader: WeatherLoader?
    var location: Location? {
        didSet {
            update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        update()
        Timer.scheduledTimer(
            timeInterval: 15 * 60,
            target: self,
            selector: #selector(update),
            userInfo: nil,
            repeats: true
        )
    }
    
    @IBAction private func openWeatherAction(_ sender: NSButton) {
        let url = URL(string: "https://openweathermap.org")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction private func quitAction(_ sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
    
    @objc private func update() {
        guard let location = location else { return }
        weatherLoader?.loadWeather(for: location) { [weak self] weather in
            DispatchQueue.main.async {
                self?.updateUI(with: weather)
            }
        }
        weatherLoader?.loadForecast(for: location) { [weak self] forecast in
            DispatchQueue.main.async {
                self?.forecast = forecast
                self?.collectionView.reloadData()
            }
        }
    }
        
    private func setupView() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
    }
    
    private func setupCollectionView() {
        let itemId = NSUserInterfaceItemIdentifier(rawValue: "WeatherItem")
        collectionView.register(WeatherItem.self, forItemWithIdentifier: itemId)
        collectionView.dataSource = self
    }
    
    private func updateUI(with weather: Weather) {
        currentDateLable.stringValue = weather.date
        temperatureLabel.stringValue = weather.temperature
        locationLabel.stringValue = weather.cityName
        weatherConditionImageView.image = NSImage(named: weather.condition)
        weatherConditionLabel.stringValue = weather.condition
    }
}

extension WeatherViewController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        forecast.count
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        itemForRepresentedObjectAt indexPath: IndexPath
    ) -> NSCollectionViewItem {
        let itemId = NSUserInterfaceItemIdentifier(rawValue: "WeatherItem")
        let item = collectionView.makeItem(withIdentifier: itemId, for: indexPath) as! WeatherItem
        item.configure(with: forecast[indexPath.item])
        return item
    }
}

extension WeatherViewController: NSCollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: NSCollectionView,
        layout collectionViewLayout: NSCollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> NSSize {
        NSSize(width: 124, height: 124)
    }
}
