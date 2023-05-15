//
//  Utilities.swift
//  movie from URL
//
//  Created by Mac on 13/05/2023.
//

import Foundation
import UIKit
class Utilities {
    
     static let getInstance = Utilities()
    
     let deleteMovieAlertTitle = " Delete Movie !"
    let deleteFromFavAlertTitle = " Remove from Favorites !"
    let addToFavAlertTitle = " Add To Favorites "
    let deleteMovieAlertMessage = "Are you sure you want to delete this movie?"
    let addToFavAlertMessage = "Are you sure you want to add this item to favorites?"
    let deleteFromFavAlertMessage = "Are you sure you want to remove this item from favorites?"
   
   
    
    private init(){
        
    }
    
    func showAlertWithTwoActions(inside: UIViewController ,title: String, message: String, firstActionName : String = "Delete" , firstActionHeader: (() -> Void)? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: firstActionName , style: .destructive) { _ in
            firstActionHeader?()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel , handler: nil)
        
        alert.addAction(firstAction)
        alert.addAction(cancelAction)
        
        inside.present(alert, animated: true, completion: nil)
    }

    
}
