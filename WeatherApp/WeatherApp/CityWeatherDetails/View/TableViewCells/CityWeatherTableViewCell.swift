//
//  CityWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by User on 02.04.2021.
//

import UIKit

final class CityWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dayTemperatureValue: UILabel!
    @IBOutlet weak var nightTemperatureValue: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
