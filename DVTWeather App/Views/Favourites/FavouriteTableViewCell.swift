//
//  FavouriteTableViewCell.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 01/03/2022.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFavouriteData(data: FavouriteData){
        if data.weatherData != nil {
            self.lblCity.text = data.weatherData.name
            self.lblTemp.text = Utils.formatTemp(temp: data.weatherData.main!.temp)
            self.lblDate.text = data.weatherData.dt.getDateTime()
        }
        
    }
    
}
