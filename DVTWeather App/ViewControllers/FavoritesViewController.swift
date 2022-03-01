//
//  FavoritesViewController.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 28/02/2022.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableFavourites: UITableView!
    // MARK: - Variables
    var favouriteList: [FavouriteData] = []
    let viewModel = FavouritesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerTableViewCells()
        self.tableFavourites.tableFooterView = UIView(frame: .zero)
        viewModel.getFavouritesList()
        
        
        viewModel.favouritesList.bind { [weak self] list in
            
            self?.favouriteList = list
            self?.tableFavourites.reloadData()
            
        }
        
    }
    
    
    private func registerTableViewCells() {
        let favouriteTableViewCell = UINib(nibName: "FavouriteTableViewCell",
                                  bundle: nil)
        self.tableFavourites.register(favouriteTableViewCell,
                                forCellReuseIdentifier: "FavouriteTableViewCell")
    }

    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
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
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as? FavouriteTableViewCell {
            
            let favouritesData = favouriteList[indexPath.row]
            cell.setFavouriteData(data: favouritesData)
            
            return cell
            
        }
           return UITableViewCell()
    }
    
    
}
extension FavoritesViewController: UITableViewDelegate {
    
}
