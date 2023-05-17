//
//  HomePresenter.swift
//  movie from URL
//
//  Created by Mac on 17/05/2023.
//

import Foundation

class HomePresenter {
    
    var allData : [Item]! = []
    
    var favData : [Item]! = []
    
    var LocalItemsInstance : LocalDataSource
    
    var NetworkingDataInstance : NetworkingDataSource
    
    weak var view : HomeViewProtocol! 
    
    let getConnectivityInstance = Connectivity.sharedInstance

    init(view: HomeViewProtocol!) {
        
         LocalItemsInstance = CoreDataDataSource.getInstance
        NetworkingDataInstance = URLSessionNetworkingDataSource(url: Connectivity.sharedInstance.APIUrl)
        self.view = view
    }
    
    func getDataFromAPI () {
        
        if getConnectivityInstance.isConnectedToInternet() {
            
            NetworkingDataInstance.loadDataFromAPI { [weak self] (result : MyResult?) in
                
                self!.LocalItemsInstance.deleteAllData()
                if let items = result?.items {
                    self!.allData = items
                    self!.LocalItemsInstance.insertDataToDB(items: items)
                   
                        }
                DispatchQueue.main.async {
                    self!.view.renderCollectionView()
                }
            }
            
        }else{
            allData = LocalItemsInstance.loadDataFromDB(isFromFav: false)
            view.renderCollectionView()
            
        }
    }
    
    func updataData(){
        allData = self.LocalItemsInstance.loadDataFromDB(isFromFav: false)
        favData = self.LocalItemsInstance.loadDataFromDB(isFromFav: true)
    }
}



