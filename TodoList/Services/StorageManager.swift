//
//  StorageManager.swift
//  TodoList
//
//  Created by Анна Белова on 16.08.2024.
//

import Foundation
import CoreData

final class StorageManager {
   static let shared = StorageManager()
    
    private init() {}
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
     func fetchData() -> [TodoTask] {
        let fetchRequest = TodoTask.fetchRequest()
        
        do {
         return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func updateData(task: TodoTask, newTitle: String) {
        task.title = newTitle
        saveContext()
    }
    
    //  MARK: - Core Data Delete support
    func deleteContext(task: TodoTask) {
        let context = persistentContainer.viewContext
        context.delete(task)
        
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
