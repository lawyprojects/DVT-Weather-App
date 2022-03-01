//
//  WeatherForecastTableViewCell.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 24/02/2022.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    
    // MARK - Properties
    @IBOutlet var lblDay: UILabel!

    @IBOutlet weak var lblWeatherImage: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // SET FORCAST DATA
    func setForecastData(data: ForecastInfo){
        lblDay.text = data.dayOfWeek
        lblWeatherImage.image = Utils.getWeatherIcon(weather: data.weather)
        lblTemperature.text = data.temp
        
        
        
    }
    
}
