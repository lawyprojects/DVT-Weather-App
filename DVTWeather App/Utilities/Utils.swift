//
//  Utils.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 26/02/2022.
//

import Foundation
import UIKit

enum WeatherType: String {
    case Sunny = "Sun"
    case Rainy = "Rain"
    case Cloudy = "Cloud"
}

public class Utils {
    
    static func getFormattedDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let formattedDate = formatter.string(from: date)
        
        return formattedDate;
    }
    
    // FORMAT TEMP
    public static func formatTemp(temp: Double)->String {
        return "\(Int(round(temp)))\u{00B0}"
    }
    
    //
    static func getWeatherBackground(weather: String)->WeatherBackground {
        if weather.contains(WeatherType.Sunny.rawValue){
            return WeatherBackground(backgroundImage: UIImage(named: "forest_sunny"), backgroundColor: UIColor(named: "SunnyColor"))
        }
        if weather.contains(WeatherType.Rainy.rawValue){
            return WeatherBackground(backgroundImage: UIImage(named: "forest_rainy"), backgroundColor: UIColor(named: "RainyColor"))
        }
        if weather.contains(WeatherType.Cloudy.rawValue){
            return WeatherBackground(backgroundImage: UIImage(named: "forest_cloudy"), backgroundColor: UIColor(named: "CloudyColor"))
        }
        
        return WeatherBackground(backgroundImage: UIImage(named: "forest_sunny"), backgroundColor: UIColor(named: "SunnyColor"))
            
    }
    
    static func getWeatherIcon(weather: String)->UIImage {
        if weather.contains(WeatherType.Sunny.rawValue){
            return UIImage(named: "partlysunny")!
        }
        if weather.contains(WeatherType.Rainy.rawValue){
            return UIImage(named: "rain")!
        }
        if weather.contains(WeatherType.Cloudy.rawValue){
            return UIImage(systemName: "cloud.fill")!
        }
        
        return UIImage(named: "clear")!
            
    }
    
    // GET 5 DAY WEATHER FORECAST
    static func get5DayWeatherForecast(listItem: [ListItem])->[ForecastInfo]{
        var forecastList:[ForecastInfo] = []
        for (key, item) in listItem.enumerated() {
            let date = item.dtTxt
            let dt = item.dt;
            
            // ADD FIRST FORECAST
            if(key == 0){
                let forecastItem = ForecastInfo(forcastDate: dt.getDate(), dayOfWeek: dt.getDayOfWeek(), time: dt.getTime(), weather: item.weather[0].main, temp: formatTemp(temp: item.main.temp))
                forecastList.append(forecastItem )
            }else {
                // ADD SUBSEQUEST DAYS FOR THE SAME TIME
                let hasDayOfWeek  = forecastList.contains(where: { $0.dayOfWeek == dt.getDayOfWeek() })
                if(hasDayOfWeek==false){
                    if(dt.getTime() == forecastList[0].time){
                        let forecastItem = ForecastInfo(forcastDate: dt.getDate(), dayOfWeek: dt.getDayOfWeek(), time: dt.getTime(), weather: item.weather[0].main, temp: formatTemp(temp: item.main.temp))
                        forecastList.append(forecastItem )
                    }
                    
                }
            }
            
            
        }
        
        return forecastList
    }
    
    
    public static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    // DECODE JSON
    public static func jsonDecode<T: Decodable>(jsonDataString: String, type: T.Type)-> Any{
        let jsonDecoder = JSONDecoder()
        let jsonData = jsonDataString.data(using: .utf8)!
        let decodedData = try! jsonDecoder.decode(type, from: jsonData)
        
        return decodedData
    }
    
    // ENCODE JSON
    static func jsonEncode<T: Encodable>(value: T) -> String{
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(value)
                let encodedData  = String(data: data, encoding: String.Encoding.utf8) ?? ""
                return encodedData
            }catch {
                print("encode error: \(error)")
                return ""
            }
        }
}

// WEATHER BACKGROUND
struct WeatherBackground {
    let backgroundImage: UIImage?
    let backgroundColor: UIColor?
}


