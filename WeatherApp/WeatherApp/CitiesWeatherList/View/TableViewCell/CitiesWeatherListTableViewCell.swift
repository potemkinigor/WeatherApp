//
//  CitiesWeatherListTableViewCell.swift
//  WeatherApp
//
//  Created by User on 01.04.2021.
//

import UIKit

final class CitiesWeatherListTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityWeatherPicture: UIImageView!
    
    @IBOutlet weak var cityTempratureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
