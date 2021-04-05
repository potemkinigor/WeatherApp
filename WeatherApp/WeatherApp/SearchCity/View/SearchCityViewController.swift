//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by User on 02.04.2021.
//

import UIKit

final class SearchCityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var listOfCities: [Cities] = []
    var errorMessage = ""
    
    var mainViewDelegate: PassSearchCityProtocol!
    var parentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SearchCityTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCityTableViewCellReuseIdentifier")
        
        mainViewDelegate = parentVC as! CitiesWeatherListViewController
        
        self.view.backgroundColor = backgroundColor
        self.tableView.backgroundColor = backgroundColor
        
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Table view data source & delegaate

extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listOfCities.count == 0{
            return 1
        }
         
        return listOfCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCityTableViewCellReuseIdentifier") as! SearchCityTableViewCell
        
        if listOfCities.count == 0 {
            cell.cityNameLabel.text = errorMessage
        } else {
            cell.cityNameLabel.text = listOfCities[indexPath.row].name
        }
        
        cell.backgroundColor = backgroundColor

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainViewDelegate.addNewCity(city: listOfCities[indexPath.row])
        
        self.dismiss(animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
