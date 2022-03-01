//
//  WeatherViewController.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 24/02/2022.
//

import UIKit
import MapKit
import CoreLocation
class WeatherViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var imgCurrentWeather: UIImageView!
    @IBOutlet weak var lblTemparature: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var lblMinTemperature: UILabel!
    @IBOutlet weak var lblMaxTemperature: UILabel!
    @IBOutlet weak var lblLastUpdateDate: UILabel!
    
    @IBOutlet weak var lblCurrentTemperature: UILabel!
    @IBOutlet var weatherBgView: UIView!
    @IBOutlet weak var tableViewForecast: UITableView!
    
    // MARK: - Constants
    let viewModel = WeatherViewModel()
    
    let manager = CLLocationManager()
    var myLocationCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var forecastList:[ForecastInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableViewCells()
        
        setWeatherData()
        manager.delegate = self
        
        getCurrentLocation()
    }
    
    private func registerTableViewCells() {
        let weatherForecastTableViewCell = UINib(nibName: "WeatherForecastTableViewCell",
                                  bundle: nil)
        self.tableViewForecast.register(weatherForecastTableViewCell,
                                forCellReuseIdentifier: "WeatherForecastTableViewCell")
    }

    // MARK: - Set Weather Data
    func setWeatherData(){
        // LAST UPDATE
        viewModel.last_update.bind { [weak self] last_update in
            self?.lblLastUpdateDate.text = last_update
        }
        // TEMP
        viewModel.temp.bind { [weak self] temp in
            self?.lblTemparature.text = temp
        }
        // TEMP - WEATHER
        viewModel.weather.bind { [weak self] weather in
            self?.lblWeather.text = weather
        }
        
        // TEMP - MIN
        viewModel.tempMin.bind { [weak self] tempMin in
            self?.lblMinTemperature.text = tempMin
        }
        // TEMP - CURRENT
        viewModel.tempCurrent.bind { [weak self] tempCurrent in
            self?.lblCurrentTemperature.text = tempCurrent
        }
        // TEMP - MAX
        viewModel.tempMax.bind { [weak self] tempMax in
            self?.lblMaxTemperature.text = tempMax
        }
        
        // BACKGROUND IMAGE
        viewModel.backgroundImage.bind { [weak self] image in
          self?.imgCurrentWeather.image = image
        }
        // BACKGROUND COLOR
        viewModel.backgroundColor.bind { [weak self] color in
          self?.weatherBgView.backgroundColor = color
        }
        
        // FORECAST DATA
        viewModel.forecastList.bind { [weak self] listItem in
            self?.forecastList = listItem
            self?.tableViewForecast.reloadData()
        }
        
        
    }
    
    private func getCurrentLocation() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    // MARK: - Actions
    @IBAction func saveWeatherInfo(_ sender: Any) {
        if viewModel.addToFavourite() == true {
            showSuccessAlert()
        }
    }
    
    @IBAction func viewFavorites(_ sender: Any) {
        
        var uiAlert = UIAlertController(title: "Favourites", message: "Weather Favourites", preferredStyle: .actionSheet)
          self.present(uiAlert, animated: true, completion: nil)

          uiAlert.addAction(UIAlertAction(title: "List", style: .default, handler: { action in
              self.showList()
          
          }))

          uiAlert.addAction(UIAlertAction(title: "Map", style: .default, handler: { action in
              self.showMap()
          }))
        
        
        
    }
    
    func showList(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let favouritesVC = storyBoard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        favouritesVC.modalPresentationStyle = .fullScreen
        self.present(favouritesVC, animated: true, completion: nil)
    }
    
    func showMap(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let favouritesVC = storyBoard.instantiateViewController(withIdentifier: "FavouritesMapViewController") as! FavouritesMapViewController
        favouritesVC.modalPresentationStyle = .fullScreen
        self.present(favouritesVC, animated: true, completion: nil)
    }
    func showSuccessAlert(){
        Utils.showBasicAlert(on: self, with: "Success", message: "Added to Favourite")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WeatherViewController : UITableViewDelegate {
    
}

extension WeatherViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    

        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastTableViewCell", for: indexPath) as? WeatherForecastTableViewCell {
            
            let forcastData = forecastList[indexPath.row]
            cell.setForecastData(data: forcastData)
        
            
            return cell
            
        }
           return UITableViewCell()
        
      
    }

}

// MARK: CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            guard let myCurrentLocation = manager.location else {
                return
            }
            
            viewModel.getWeather(latitude: myCurrentLocation.coordinate.latitude, longitude: myCurrentLocation.coordinate.longitude)
            viewModel.getWeatherForecast(latitude: myCurrentLocation.coordinate.latitude, longitude: myCurrentLocation.coordinate.longitude)
          
        } else {
            print("user denied access")
            
        }
    }
}
