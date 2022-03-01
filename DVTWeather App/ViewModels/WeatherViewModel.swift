//
//  WeatherViewModel.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 25/02/2022.
//

import Foundation
import UIKit
import MapKit

public class WeatherViewModel  {
    // MARK: - Constants
    let weatherPath = "/data/2.5/weather"
    let forecastPath = "/data/2.5/forecast"
    
   
    // MARK: Variables
    var apiService = APIService();
    
    var weatherData: WeatherData?
    var forecastData: ForecastData?
    
    let temp = DataBind("0")
    let weather = DataBind("")
    let tempMin = DataBind("0")
    let tempCurrent = DataBind("0")
    let tempMax = DataBind("0")
    let backgroundImage: DataBind<UIImage?> = DataBind(UIImage(named: "forest_sunny"))
    let backgroundColor: DataBind<UIColor?> = DataBind(UIColor(named: "SunnyColor"))
    let forecastList: DataBind<[ForecastInfo]> = DataBind([])
    let last_update = DataBind("")
    
    init(){
       self.getSaveWeatherForecast()
    }
    
    
    // GET Weather
    public func getWeather(latitude: Double,longitude: Double){
        let queryParams = [
            "lat":String(latitude) ,
            "lon":String(longitude),
            "units":"metric",
            "appid":Constants.weatherAPI_key
        ]
        
        let weatherRequest = APIServiceRequest(method: .get, path: weatherPath, queryItems: queryParams)
        apiService.APIServiceRequest(request: weatherRequest, apiServiceTask: { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: WeatherData.self) {
                   
                    DispatchQueue.main.async {
                        //self.refreshControl.endRefreshing()
                        self.weatherData = response.body
                        self.setWeatherData(weatherData: response.body!)
                        
                    }
                    
                } else {
                    print(Error.decodingError)
                }
            case .failure:
                print(Error.networkError)
            }
        })
    }
    
  // MARK: Set - Weather Data
    private func setWeatherData(weatherData: WeatherData){
        
        // TEMP
        if let main = weatherData.main {
            self.temp.value = Utils.formatTemp(temp: main.temp)
            // TEMP - MIN
            self.tempMin.value =  Utils.formatTemp(temp: main.tempMin)
            // TEMP - CURRENT
            self.tempCurrent.value = Utils.formatTemp(temp: main.temp)
            // TEMP - MAX
            self.tempMax.value = Utils.formatTemp(temp: main.tempMax)
        }
        
        // WEATHER
        if let weather = weatherData.weather {
            if weather.count > 0 {
                self.weather.value = weather[0].main
                
                let weatherBg = Utils.getWeatherBackground(weather: weather[0].main)
                self.backgroundImage.value = weatherBg.backgroundImage
                self.backgroundColor.value = weatherBg.backgroundColor
                    
                
            }
            
        }
       
    }
    
    
    // GET Weather Forecast
    public func getWeatherForecast(latitude: Double,longitude: Double){
        let queryParams = [
            "lat":String(latitude) ,
            "lon":String(longitude),
            "units":"metric",
            "appid":Constants.weatherAPI_key
        ]
        
        let weatherRequest = APIServiceRequest(method: .get, path: forecastPath, queryItems: queryParams)
        apiService.APIServiceRequest(request: weatherRequest, apiServiceTask: { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                if let response = try? response.decode(to: ForecastData.self) {
                    self.forecastData = response.body
                    WeatherDataUtils().addCurrentWeather(weather: Utils.jsonEncode(value: self.weatherData) , forecast: Utils.jsonEncode(value: self.forecastData))
                    DispatchQueue.main.async {
                        
                        self.setForecastData(forecastData: response.body!)
                        
                    }
                    
                } else {
                    print(Error.decodingError)
                }
            case .failure:
                print(Error.networkError)
            }
        })
    }
    
    // MARK: Set Weather Forecast
    func setForecastData(forecastData: ForecastData){
        self.forecastList.value = Utils.get5DayWeatherForecast(listItem: forecastData.list)
    }
    
    // ADD TO FAVOURITE
    func addToFavourite()->Bool{
        let weatherData = Utils.jsonEncode(value: self.weatherData)
        
        
        let forecastData = Utils.jsonEncode(value: forecastData)
        return WeatherDataUtils().addToFavourites(weather: weatherData, forecast: forecastData)
        
        
        
    }
    
    func getSaveWeatherForecast(){
        if WeatherDataUtils().getCurrentWeather() != nil {
            let result = WeatherDataUtils().getCurrentWeather()
            let weatherData: WeatherData = result.weatherData
            let forecastData = result.forecastData
            
            if weatherData != nil {
                self.setWeatherData(weatherData: weatherData)
            }
            if forecastData != nil {
                self.setForecastData(forecastData: forecastData)
            }
           
            self.last_update.value = result.last_update
        }
    }
}

