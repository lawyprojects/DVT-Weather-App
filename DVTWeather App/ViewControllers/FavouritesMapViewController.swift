//
//  FavouritesMapViewController.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 01/03/2022.
//

import UIKit
import MapKit
import CoreLocation

class FavouritesMapViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variables
    let viewModel = FavouritesViewModel()
    let manager = CLLocationManager()
    
    var myLocationCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LOCATION MANAGER
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        viewModel.getFavouritesList()
        
        setFavouriteData()
        
      
    }
    
    
    func setFavouriteData(){
        viewModel.favouritesList.bind { [weak self] list in
            self?.addLocationsToMap(list: list)
        }
    }
    func addLocationsToMap(list: [FavouriteData]){
        for item in list{
            if item.weatherData != nil {
                let weather = item.weatherData
                let annotations = MKPointAnnotation()
                var annotationArray = [MKPointAnnotation]()
                
                let lat = weather.coord.lon ?? 0.00
                let lon = weather.coord.lat ?? 0.00
                
                let multipleCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                annotations.title = weather.name
                annotations.coordinate = multipleCoordinates
                self.mapView.addAnnotation(annotations)
                DispatchQueue.main.async {
                   
                }
            }
           
           
            
        }
    }
    
    func setMyLocation(_ location : CLLocation){
        
        myLocationCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegion(center: myLocationCoordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)

        let myLocationPin = MKPointAnnotation()
        myLocationPin.coordinate = myLocationCoordinate
        myLocationPin.title = "Location"
        myLocationPin.subtitle = "My Current Location"
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(myLocationPin)
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
extension FavouritesMapViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            setMyLocation(location)
        }
    }
}
