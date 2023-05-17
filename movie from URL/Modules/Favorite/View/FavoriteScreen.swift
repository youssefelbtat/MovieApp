//
//  FavoriteScreen.swift
//  movie from URL
//
//  Created by Mac on 08/05/2023.
//


import UIKit

protocol FavoriteViewProtocol : AnyObject{
    
    
}



class FavoriteScreen: UIViewController , UITableViewDelegate , UITableViewDataSource , FavoriteViewProtocol{
 
    

    @IBOutlet weak var btnBackToAddFavMovie: UIButton!
    @IBOutlet weak var tv_noMovies: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    var favMoviesArray : [Item] = []
    var presenter : FavoritePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        presenter = FavoritePresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.loadFavItemsFromDB()
        favMoviesArray = presenter.favMoviesArray
        
        refrashViewAfter()
       
    }
    
    func refrashViewAfter(){
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
    
    @IBAction func backToHomeAddMoviesToFavAction(_ sender: Any) {
        if let tab = self.tabBarController {
            tab.selectedIndex = 0
        }
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
            //show alert
            Utilities.getInstance.showAlertWithTwoActions(inside: self, title: Utilities.getInstance.deleteMovieAlertTitle, message: Utilities.getInstance.deleteMovieAlertMessage, firstActionHeader: {
                
                self.presenter.deleteItemFromFav(id: self.favMoviesArray[indexPath.row].id!)
                
                self.favMoviesArray.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                self.refrashViewAfter()
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
    

}

