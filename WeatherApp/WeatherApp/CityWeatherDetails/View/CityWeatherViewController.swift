//
//  CityWeatherViewController.swift
//  WeatherApp
//
//  Created by User on 02.04.2021.
//

import UIKit

final class CityWeatherViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var cityName: String!
    var cityLattitude: Double!
    var cityLongitude: Double!
    
    var hoursData: [WeatherByHours] = []
    var daysData: [WeatherByDays] = []
    
    let imageCache = ImagesCache.shared
    
    var presenterProtocol: CityWeatherDetailsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        presenterProtocol.loadCityWeather(cityName: cityName, lattitude: cityLattitude, longitude: cityLongitude)
        
        tableView.register(UINib(nibName: "CityWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "CityWeatherTableViewCellReuseIdentifier")
        
        tableView.register(UINib(nibName: "HourlyCityWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyCityWeatherTableViewCellReuseIdentifier")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.backgroundColor = backgroundColor
        self.tableView.backgroundColor = backgroundColor
    }

    @IBAction func closeDetails(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Table view data source and delegate

extension CityWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyCityWeatherTableViewCellReuseIdentifier") as! HourlyCityWeatherTableViewCell
            
            cell.hoursData = self.hoursData
            cell.collectionView.reloadData()
            
            cell.backgroundColor = backgroundColor
            cell.collectionView.backgroundColor = backgroundColor
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityWeatherTableViewCellReuseIdentifier") as! CityWeatherTableViewCell
            
            let index = indexPath.row - 1
            
            cell.dayOfWeekLabel.text = daysData[index].dayOfWeek
            cell.dayTemperatureValue.text = String(daysData[index].temperatureDay) + "\u{00B0}"
            cell.nightTemperatureValue.text = String(daysData[index].temperatureNight) + "\u{00B0}"
            
            var image = imageCache.imagesCache[daysData[index].iconURL]
            
            if image == nil {
                image = UIImage(named: "noInfo")
            }
            
            cell.weatherImageView.image = image
            
            cell.backgroundColor = backgroundColor
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return 80
        }
    }
    
}

//MARK: - Presenter protocol

extension CityWeatherViewController: CityWeatherDetailsViewProtocol {
    func updateData(hoursData: [WeatherByHours], daysData: [WeatherByDays], cityName: String, temperature: Int, currentWeatherIconURL: String) {
        self.hoursData = hoursData
        self.daysData = daysData
        
        self.cityNameLabel.text = cityName
        self.currentTemperatureLabel.text = String(temperature)+"\u{00B0}"
        
        var image = imageCache.imagesCache[currentWeatherIconURL]
        
        if image == nil {
            image = UIImage(named: "noInfo")
        }
        
        self.currentWeatherImageView.image = image
        
        self.tableView.reloadData()
    }
    
    func presentNetworkAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
     
}
