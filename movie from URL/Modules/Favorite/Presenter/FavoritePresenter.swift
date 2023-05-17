//
//  FavoritePresenter.swift
//  movie from URL
//
//  Created by Mac on 17/05/2023.
//

import Foundation

class FavoritePresenter {
    
    var favMoviesArray : [Item] = []
    
    var LocalItemsInstance : LocalDataSource
    
    weak var view : FavoriteViewProtocol!
    

    init(view: FavoriteViewProtocol!) {
        
         LocalItemsInstance = CoreDataDataSource.getInstance
        
         self.view = view
    }
    
    func loadFavItemsFromDB() {
        
        favMoviesArray = LocalItemsInstance.loadDataFromDB(isFromFav: true)
    }
    
    func deleteItemFromFav(id : String){
        
        self.LocalItemsInstance.deleteMovie(id: id , isFromFav: true)
        
    }
    
    
    
}

