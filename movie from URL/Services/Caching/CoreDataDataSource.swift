//
//  DataSource.swift
//  movie from URL
//
//  Created by Mac on 08/05/2023.
//

import Foundation
import UIKit
import CoreData


protocol LocalDataSource {
    func insertDataToDB(items : [Item])
    func addItemToFav(item: Item)
    func loadDataFromDB(isFromFav: Bool)->[Item]
    func deleteMovie(id: String,isFromFav: Bool)
    func deleteAllData()
}

class CoreDataDataSource : LocalDataSource{
    
    static let getInstance = CoreDataDataSource()
    
    private let favEntityName = "FavEntity"
    private let mainEntityName = "ItemEntity"
    private var manager : NSManagedObjectContext!
    private var itemsNS : [NSManagedObject] = []
    
    private init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        manager = appDelegate.persistentContainer.viewContext
    }
    
    
    func insertDataToDB(items : [Item]){
        
        let entity = NSEntityDescription.entity(forEntityName: mainEntityName, in: manager)
        
        for item in items {
            let itemEntity = NSManagedObject(entity: entity!, insertInto: manager)
            itemEntity.setValue(item.id, forKey: "id")
            itemEntity.setValue(item.image, forKey: "image")
            itemEntity.setValue(item.weekend, forKey: "weekend")
            itemEntity.setValue(item.gross , forKey: "gross")
            itemEntity.setValue(item.rank, forKey: "rank")
            itemEntity.setValue(item.weeks, forKey: "weeks")
            itemEntity.setValue(item.header, forKey: "header")
        }
        
        do{
            try manager.save()
            print("The Items Added successfully .")
        }catch let e{
            print("Error when add data  : \(e.localizedDescription)")
        }
        
    }
    
    func addItemToFav(item: Item){
        
        let entity = NSEntityDescription.entity(forEntityName: favEntityName, in: manager)
        
        let itemEntity = NSManagedObject(entity: entity!, insertInto: manager)
        
        itemEntity.setValue(item.id, forKey: "id")
        itemEntity.setValue(item.image, forKey: "image")
        itemEntity.setValue(item.weekend, forKey: "weekend")
        itemEntity.setValue(item.gross , forKey: "gross")
        itemEntity.setValue(item.rank, forKey: "rank")
        itemEntity.setValue(item.weeks, forKey: "weeks")
        itemEntity.setValue(item.header, forKey: "header")
        
        do{
            try manager.save()
            print("The Items with id \(item.id!) added to fav successfully .")
        }catch let e{
            print("Error when add item to fav  : \(e.localizedDescription)")
        }
        
    }
    
    func loadDataFromDB(isFromFav: Bool)->[Item]{
        
        var fetch = NSFetchRequest<NSManagedObject>(entityName: mainEntityName)
        
        if isFromFav {
            fetch = NSFetchRequest<NSManagedObject>(entityName: favEntityName)
        }
        var items = [Item]()
        
        do{
            itemsNS = try manager.fetch(fetch)
            
            for item in itemsNS{
                let id = item.value(forKey: "id") as! String
                let header = item.value(forKey: "header") as! String
                let weeks = item.value(forKey: "weeks") as! String
                let gross = item.value(forKey: "gross") as! String
                let image = item.value(forKey: "image") as! String
                let weekend = item.value(forKey: "weekend") as! String
                let rank = item.value(forKey: "rank") as! String
                
                
                let item = Item(id: id, rank: rank, header: header, image: image, weekend: weekend, gross: gross, weeks: weeks)
                items.append(item)
            }
       
        }catch let error{
            print("Error when fetch all data : \(error.localizedDescription)")
        }
       

       return items
        
    }
    
    func deleteMovie(id: String,isFromFav: Bool) {
        
        var fetch = NSFetchRequest<NSFetchRequestResult>(entityName: mainEntityName)
        
        if isFromFav {
            fetch = NSFetchRequest<NSFetchRequestResult>(entityName: favEntityName)
        }
       
        fetch.predicate = NSPredicate(format: "id == %@", id)

        do {
            let fetchResults = try manager.fetch(fetch) as? [NSManagedObject]
            if let item = fetchResults?.first {
                manager.delete(item)
                try manager.save()
                print("Item with id \(id) deleted successfully")
            }
        } catch let error {
            print("Error deleting Item with id \(id): \(error.localizedDescription)")
        }
    }
    
    func deleteAllData() {
        
        let fetcht = NSFetchRequest<NSFetchRequestResult>(entityName: mainEntityName)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetcht)
        
        do {
            try manager.execute(deleteRequest)
            print("All data deleted successfully.")
        } catch {
            print("Error deleting data: \(error)")
        }
    }

    
}
