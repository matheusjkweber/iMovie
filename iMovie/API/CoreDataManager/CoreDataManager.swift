//
//  CoreDataManager.swift
//  iMovie
//
//  Created by Matheus Weber on 26/06/19.
//  Copyright © 2019 Matheus Weber. All rights reserved.
//

import CoreData

class CoreDataManager {
    static var appDelegate = AppDelegate()
    static var shared = CoreDataManager()
    
    var managedContext: NSManagedObjectContext
    
    init() {
        managedContext = CoreDataManager.appDelegate.persistentContainer.viewContext
    }
    
    func alreadyAdded(with id: Int, and type: MediaType) -> Bool {
        let mediaFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Media")
        let idKeyPredicate = NSPredicate(format: "id = %@", "\(id)")
        let typePredicate = NSPredicate(format: "type = %@", type.rawValue)
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [idKeyPredicate, typePredicate])
        mediaFetch.predicate = andPredicate
        
        do {
            let medias = try managedContext.fetch(mediaFetch)
            return !medias.isEmpty
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return false
    }
    
    func addMedia(mediaModel: ShowMediaModel) {
        if !alreadyAdded(with: mediaModel.id, and: mediaModel.type) {
            let mediaEntity = NSEntityDescription.entity(forEntityName: "Media", in: managedContext)!
            
            let mediaObject = NSManagedObject(entity: mediaEntity, insertInto: managedContext)
            mediaObject.setValue(mediaModel.id, forKey: "id")
            mediaObject.setValue(mediaModel.popularity, forKey: "popularity")
            mediaObject.setValue(mediaModel.posterPath, forKey: "posterPath")
            mediaObject.setValue(mediaModel.releaseDate, forKey: "releaseDate")
            mediaObject.setValue(mediaModel.type.rawValue, forKey: "type")
            mediaObject.setValue(mediaModel.title, forKey: "title")
            mediaObject.setValue(mediaModel.voteAverage, forKey: "voteAverage")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addMultipleMedia(showMediaArray: [ShowMediaModel]) {
        for media in showMediaArray {
            addMedia(mediaModel: media)
        }
    }
    
    func emptyMedia() {
        deleteAllData(entity: "Media")
    }
    
    func retrieveMedias(limit: Int, offset: Int, orderedBy: Type) -> [ShowMediaModel] {
        let mediaFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Media")
        mediaFetch.sortDescriptors = [NSSortDescriptor(key: orderedBy.rawValue, ascending: false)]
        mediaFetch.fetchLimit = limit
        mediaFetch.fetchOffset = offset
        
        var mediaList = [ShowMediaModel]()
        do {
            if let medias = try managedContext.fetch(mediaFetch) as? [Media] {
                for media in medias {
                    let mediaModel = ShowMediaModel(from: media)
                    mediaList.append(mediaModel)
                }
            }
        } catch let error as NSError {
            print("Could not load. \(error), \(error.userInfo)")
        }
        
        return mediaList
    }
    
    func retrieveNumberOfMedia() -> Int {
        let mediaFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Media")
        do {
            let count = try managedContext.count(for: mediaFetch)
            return count
        } catch {
            return 0
        }
    }
    
    func deleteAllData(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}
