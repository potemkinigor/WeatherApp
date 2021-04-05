//
//  CitiesWeatherListViewController.swift
//  WeatherApp
//
//  Created by User on 01.04.2021.
//

import UIKit

protocol PassSearchCityProtocol {
    func addNewCity(city: Cities)
}

final class CitiesWeatherListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var presenterProtocol: CitiesWeatherListPresenterProtocol!
    
    var cityWeatherList: [WeatherForecast] = []
    
    var imagesCache = ImagesCache.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CitiesWeatherListTableViewCell", bundle: nil), forCellReuseIdentifier: "citiesWeatherListTableViewCellReusableIdentifier")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBar.delegate = self
        
        self.view.backgroundColor = backgroundColor
        self.tableView.backgroundColor = backgroundColor
        self.searchBar.backgroundColor = backgroundColor
        self.searchBar.barTintColor = backgroundColor
    }

    @IBAction func infoPushAction(_ sender: Any) {
        let alert = UIAlertController(title: "Информация", message: "Фактические данные и прогноз погоды берутся с официального сайта Яндекс. Поиск городов осуществляется на русском языке. Доступны бошьшинство населеннх пунктов России", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Table view data source & delegaate

extension CitiesWeatherListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiesWeatherListTableViewCellReusableIdentifier") as! CitiesWeatherListTableViewCell
        
        cell.cityNameLabel.text = cityWeatherList[indexPath.row].geoObject?.locality?.name
        cell.cityTempratureLabel.text = String(cityWeatherList[indexPath.row].fact!.temp!) + "\u{00B0}"
        cell.cityWeatherPicture.image = imagesCache.imagesCache[(cityWeatherList[indexPath.row].fact?.icon!)!]
        
        cell.backgroundColor = backgroundColor
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenterProtocol.removeFromFavorites(city: cityWeatherList[indexPath.row])
            cityWeatherList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenterProtocol.showDetailsWindow(city: (cityWeatherList[indexPath.row].geoObject?.locality?.name)!, lattitude: (cityWeatherList[indexPath.row].info?.lat)!, longitude: (cityWeatherList[indexPath.row].info?.lon)!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
}

//MARK: - Presenter protocol

extension CitiesWeatherListViewController: CitiesWeatherListViewProtocol {
    func updateFavorites(weather: [WeatherForecast]) {
        self.cityWeatherList = weather
        self.tableView.reloadData()
    }
    
    func presentNetworkAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - SearchBar delegate

extension CitiesWeatherListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        self.presenterProtocol.searchCity(text: searchText)
               
        self.tableView.reloadData()
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
}

//MARK: - Delagates

extension CitiesWeatherListViewController: PassSearchCityProtocol {
    func addNewCity(city: Cities) {
        presenterProtocol.addToFavorites(city: city)
        self.cityWeatherList = []
        presenterProtocol.loadCurrentWeather()
        
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }
    
}

