//
//  MovieTableCell.swift
//  movie from URL
//
//  Created by Mac on 08/05/2023.
//

import UIKit

class MovieTableCell: UICollectionViewCell {
    
    let dSourceInstance = CoreDataDataSource.getInstance
    var itemToAddToFav: Item?

    var isFavorite: Bool?
    @IBOutlet weak var imgMovieImage: UIImageView!
    @IBOutlet weak var tvMovieTitle: UILabel!
    @IBOutlet weak var favIcon: UIButton!
    
    @IBAction func addToFavAction(_ sender: UIButton) {
        
        var image:UIImage!
        if !isFavorite! {
            Utilities.getInstance.showAlertWithTwoActions(inside: (self.window?.rootViewController)!, title: Utilities.getInstance.addToFavAlertTitle, message: Utilities.getInstance.addToFavAlertMessage , firstActionName: "Add"){
                self.dSourceInstance.addItemToFav(item: self.itemToAddToFav!)
                image = UIImage(systemName: "heart.fill")
                self.isFavorite!.toggle()
                self.favIcon.setImage(image, for: .normal)

            }
           
        }else{
            Utilities.getInstance.showAlertWithTwoActions(inside: (self.window?.rootViewController)!, title: Utilities.getInstance.deleteFromFavAlertTitle, message: Utilities.getInstance.deleteFromFavAlertMessage){
                self.dSourceInstance.deleteMovie(id: (self.itemToAddToFav?.id)!, isFromFav: true)
                image = UIImage(systemName: "heart")
                self.isFavorite!.toggle()
                self.favIcon.setImage(image, for: .normal)
            }
            
        }
       
        
     
    }
    

}
