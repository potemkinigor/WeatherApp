//
//  HourlyCityWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by User on 02.04.2021.
//

import UIKit

final class HourlyCityWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let imageCache = ImagesCache.shared
    var hoursData: [WeatherByHours] = []
    let imagesCache = ImagesCache.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "DailyCityWeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dailyWeatherCollectionReusableIdentifier")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Collection view data source and delegate

extension HourlyCityWeatherTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hoursData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dailyWeatherCollectionReusableIdentifier", for: indexPath) as! DailyCityWeatherCollectionViewCell
        
        cell.timeLabel.text = self.hoursData[indexPath.row].hour
        cell.temperatureLabel.text = String(self.hoursData[indexPath.row].temperature) + "\u{00B0}"
        
        var image = imagesCache.imagesCache[self.hoursData[indexPath.row].iconURL]
        
        if image == nil {
            image = UIImage(named: "noInfo")
        }
        
        cell.iconImageView.image = image
        
        cell.backgroundColor = backgroundColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
