//
//  DailyCityWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by User on 02.04.2021.
//

import UIKit

final class DailyCityWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
