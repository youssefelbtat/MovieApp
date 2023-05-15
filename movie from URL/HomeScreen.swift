//
//  HomeScreen.swift
//  movie from URL
//
//  Created by Mac on 08/05/2023.
//

import UIKit
import Kingfisher
class HomeScreen: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
   
    @IBOutlet weak var MyCollectionView: UICollectionView!
    
    @IBOutlet weak var tvNoData: UILabel!
    
    let getItemsInstance = DataSource.getInstance
    var allItemsArray : [Item]?
    var favItemsArray : [Item]?
    let getConnectivityInstance = Connectivity.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
        
        if getConnectivityInstance.isConnectedToInternet() {
            getItemsInstance.loadDataFromAPI{ [weak self] (result) in
                DispatchQueue.main.async {
                    self!.getItemsInstance.deleteAllData()
                    if let items = result?.items {
                        self!.allItemsArray = items
                        self!.getItemsInstance.insertDataToDB(items: items)
                       
                            }
                    self!.MyCollectionView.dataSource = self
                    self!.MyCollectionView.delegate = self
                    indicator.stopAnimating()
                }
            }
        }else{
            
            allItemsArray = getItemsInstance.loadDataFromDB(isFromFav: false)
            MyCollectionView.dataSource = self
            MyCollectionView.delegate = self
            indicator.stopAnimating()
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        allItemsArray = getItemsInstance.loadDataFromDB(isFromFav: false)
        favItemsArray = getItemsInstance.loadDataFromDB(isFromFav: true)
        if allItemsArray!.isEmpty{
            tvNoData.isHidden = false
            MyCollectionView.isHidden = true
        }else{
            tvNoData.isHidden = true
            MyCollectionView.isHidden = false
            MyCollectionView.reloadData()
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return allItemsArray?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width / 2 ) - 10, height: 210)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! MovieTableCell
     
        let url = URL(string: allItemsArray![indexPath.row].image!)!
        

        cell.imgMovieImage.kf.indicatorType = .activity
        cell.imgMovieImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        cell.itemToAddToFav = allItemsArray![indexPath.row]
        
        if let isFavorited = favItemsArray?.contains(where: {$0.id == allItemsArray![indexPath.row].id}) {
            if isFavorited {
                cell.isFavorite = true
                cell.favIcon.setImage(UIImage(systemName: "heart.fill"),for: .normal)
            }else {
                cell.isFavorite = false
                cell.favIcon.setImage(UIImage(systemName: "heart"),for: .normal)
            }
        }
            
        
        cell.tvMovieTitle.text = allItemsArray![indexPath.row].header ?? "No Header"
        
        return cell
        
    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let sec = self.storyboard?.instantiateViewController(withIdentifier: "sec") as! ShowItemScreen
            
         sec.itemDatels = allItemsArray![indexPath.row]
        navigationController?.pushViewController(sec, animated: true)
    }
    
}
