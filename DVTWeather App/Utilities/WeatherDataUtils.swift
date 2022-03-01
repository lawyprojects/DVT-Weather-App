//
//  WeatherDataUtils.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 01/03/2022.
//

import Foundation
import UIKit
import CoreData
public class WeatherDataUtils {
    
    let coreDataManager = CoreDataManager(modelName: "Weather")
    
    // ADD CURRENT WEATHER & FORECAST
    
    public func addCurrentWeather(weather: String,forecast: String)->Bool{
      let context = coreDataManager.managedObjectContext
      let weatherEntity = WeatherEntity(context: context)
    
        weatherEntity.current_weather = weather
        weatherEntity.forecast = forecast
        weatherEntity.last_update = Date()
        
        deleteAllData()
        do {
            try context.save()
            
            return true
        }
        catch {
            return false
        }
    }
    func deleteAllData(){
        let context = coreDataManager.managedObjectContext
        let weatherEntity = WeatherEntity(context: context)
        do {
            try  context.delete(weatherEntity)
            try context.save()
        }
        catch {
          
        }
    }
    // GET CURRENT WEATHER
    func getCurrentWeather()->(weatherData: WeatherData,forecastData: ForecastData,last_update: String){
        var weatherData: WeatherData? = nil
        var forecastData: ForecastData? = nil
        var last_update = ""
       let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherEntity")
               
               request.returnsObjectsAsFaults = false
               do {
                   let result = try coreDataManager.managedObjectContext.fetch(request)
                   for data in result as! [NSManagedObject] {
                       let weather = data.value(forKey: "current_weather") as! String
                       let forecast = data.value(forKey: "forecast") as! String
                       let last_update_date = data.value(forKey: "last_update") as! Date
                       
                       if( weather != "" && forecast != ""){
                           weatherData = Utils.jsonDecode(jsonDataString: weather, type: WeatherData.self) as! WeatherData
                           forecastData = Utils.jsonDecode(jsonDataString: forecast, type: ForecastData.self) as! ForecastData
                          
                        
                       }
                       if last_update_date != nil {
                           last_update = Utils.getFormattedDate(date: last_update_date)
                       }
                      
                 }
                   
               } catch {
                   
                   print("Failed")
               }
       
       return (weatherData!,forecastData!,last_update)

   }
    // ADD FAVOURITE
    public func addToFavourites(weather: String,forecast: String)->Bool{
      let context = coreDataManager.managedObjectContext
      let favouriteEntity = FavouritesEntity(context: context)
        favouriteEntity.weather = weather
        favouriteEntity.forecast = forecast
        
        do {
            try context.save()
            
            return true
        }
        catch {
            return false
        }
    }
    
    // FAVOURITES LIST
     func getFavouritesList()->[FavouriteData]{
        var favourites: [FavouriteData] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouritesEntity")
                
                request.returnsObjectsAsFaults = false
                do {
                    let result = try coreDataManager.managedObjectContext.fetch(request)
                    for data in result as! [NSManagedObject] {
                        let weather = data.value(forKey: "weather") as! String
                        let forecast = data.value(forKey: "forecast") as! String
                        
                        if( weather != "" && forecast != ""){
                            let favourite = FavouriteData(weatherData: Utils.jsonDecode(jsonDataString: weather, type: WeatherData.self) as! WeatherData, forecast:   Utils.jsonDecode(jsonDataString: forecast, type: ForecastData.self) as! ForecastData)
                            
                            favourites.append(favourite)
                        }
                       
                  }
                    
                } catch {
                    
                    print("Failed")
                }
        
        return favourites

    }
}
