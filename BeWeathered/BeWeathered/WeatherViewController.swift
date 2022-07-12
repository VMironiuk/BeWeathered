//
//  WeatherViewController.swift
//  BeWeathered
//
//  Created by Volodymyr Myroniuk on 07.07.2022.
//

import Cocoa

class WeatherViewController: NSViewController {

    @IBOutlet private weak var currentDateLable: NSTextField!
    @IBOutlet private weak var temperatureLabel: NSTextField!
    @IBOutlet private weak var locationLabel: NSTextField!
    @IBOutlet private weak var weatherConditionImageView: NSImageView!
    @IBOutlet private weak var weatherConditionLabel: NSTextField!
    @IBOutlet private weak var collectionView: NSCollectionView!
    
    var weatherLoader: WeatherLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        weatherLoader?.load()
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
}

extension WeatherViewController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(
        _ collectionView: NSCollectionView,
        itemForRepresentedObjectAt indexPath: IndexPath
    ) -> NSCollectionViewItem {
        let itemId = NSUserInterfaceItemIdentifier(rawValue: "WeatherItem")
        let item = collectionView.makeItem(withIdentifier: itemId, for: indexPath)
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
