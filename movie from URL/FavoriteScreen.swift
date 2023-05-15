//
//  FavoriteScreen.swift
//  movie from URL
//
//  Created by Mac on 08/05/2023.
//

import UIKit

class FavoriteScreen: UIViewController , UITableViewDelegate , UITableViewDataSource {
 
    

    @IBOutlet weak var btnBackToAddFavMovie: UIButton!
    @IBOutlet weak var tv_noMovies: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    let dataSourceInstance = DataSource.getInstance
    var favMoviesArray : [Item] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favMoviesArray = dataSourceInstance.loadDataFromDB(isFromFav: true)
        if favMoviesArray.isEmpty
        {
            myTableView.isHidden = true
            btnBackToAddFavMovie.isHidden = false
            tv_noMovies.isHidden = false
          
        }else{
            myTableView.isHidden = false
            tv_noMovies.isHidden = true
            btnBackToAddFavMovie.isHidden = true
            self.myTableView.reloadData()
        }
       
    }
    
    @IBAction func action(_ sender: Any) {
        print("Clicked out side ")
        if let tab = self.tabBarController {
            print("Clicked ")
            tab.selectedIndex = 0
        }
    }
    @IBAction func backToAddMoviesAction(_ sender: UIButton) {
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favMoviesArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = favMoviesArray[indexPath.row].header
        cell.detailTextLabel?.text = favMoviesArray[indexPath.row].gross
        cell.detailTextLabel?.sizeToFit()
        
        let url = URL(string: favMoviesArray[indexPath.row].image!)!
        
        cell.imageView!.kf.indicatorType = .activity
        cell.imageView!.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRaw = favMoviesArray[indexPath.row]
        
         let sec = self.storyboard?.instantiateViewController(withIdentifier: "sec") as! ShowItemScreen
            
            sec.itemDatels = selectedRaw
            sec.isFromFav = true
            
            navigationController?.pushViewController(sec, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            Utilities.getInstance.showAlertWithTwoActions(inside: self, title: Utilities.getInstance.deleteMovieAlertTitle, message: Utilities.getInstance.deleteMovieAlertMessage, firstActionHeader: {
                
                self.dataSourceInstance.deleteMovie(id: (self.favMoviesArray[indexPath.row].id!), isFromFav: true)
                self.favMoviesArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
    

}
