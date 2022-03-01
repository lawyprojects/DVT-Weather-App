//
//  FavouritesViewModel.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 01/03/2022.
//

import Foundation
public class FavouritesViewModel {
    // MARK: Variables
    let favouritesList: DataBind<[FavouriteData]> = DataBind([])
    
    public func getFavouritesList(){
        self.favouritesList.value = WeatherDataUtils().getFavouritesList()
    }
}
