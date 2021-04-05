//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by User on 01.04.2021.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    var container: NSPersistentContainer { get }
    func saveContext()
}

struct PersistanceContainer: CoreDataManagerProtocol {
    
    static var shared = PersistanceContainer()
    
    let container: NSPersistentContainer
    
    init() {
        self.container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores { (persistentStoreDescription, error) in
            if error != nil {
                print("Ошибка \(String(describing: error?.localizedDescription))")
            }
        }
        
    }
    
    func saveContext () {
        let context = self.container.viewContext
        
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Fatal error: \(error)")
        }
    }
}
