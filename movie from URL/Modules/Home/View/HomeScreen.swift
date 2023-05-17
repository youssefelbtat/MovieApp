//
//  HomeScreen.swift
//  movie from URL
//
//  Created by Mac on 08/05/2023.
//

import UIKit
import Kingfisher

protocol HomeViewProtocol : AnyObject{
    
    func renderCollectionView ()
    
}



class HomeScreen: UIViewController,HomeViewProtocol,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
   
    @IBOutlet weak var MyCollectionView: UICollectionView!
    
    @IBOutlet weak var tvNoData: UILabel!
    
    var presenter : HomePresenter!
    
  

    var indicator : UIActivityIndicatorView!
    override func viewDidLoad() {
        presenter = HomePresenter(view: self)
        super.viewDidLoad()
     
         indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
        presenter.getDataFromAPI()
       
    }
    func renderCollectionView() {
        MyCollectionView.dataSource = self
        MyCollectionView.delegate = self
        self.indicator.stopAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        presenter.updataData()
        
        if presenter.allData.isEmpty{
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
        
        
        return presenter.allData?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width / 2 ) - 10, height: 210)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! MovieTableCell
     
        let url = URL(string: presenter.allData![indexPath.row].image!)!
        

        cell.imgMovieImage.kf.indicatorType = .activity
        cell.imgMovieImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        cell.itemToAddToFav = presenter.allData![indexPath.row]
        
        if let isFavorited = presenter.favData?.contains(where: {$0.id == presenter.allData![indexPath.row].id}) {
            if isFavorited {
                cell.isFavorite = true
                cell.favIcon.setImage(UIImage(systemName: "heart.fill"),for: .normal)
            }else {
                cell.isFavorite = false
                cell.favIcon.setImage(UIImage(systemName: "heart"),for: .normal)
            }
        }
            
        
        cell.tvMovieTitle.text = presenter.allData![indexPath.row].header ?? "No Header"
        
        return cell
        
    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let sec = self.storyboard?.instantiateViewController(withIdentifier: "sec") as! ShowItemScreen
            
         sec.itemDatels = presenter.allData![indexPath.row]
        navigationController?.pushViewController(sec, animated: true)
    }
    
}
