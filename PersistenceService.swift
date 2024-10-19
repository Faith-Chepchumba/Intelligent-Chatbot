// PersistenceService.swift
import Foundation
import CoreData

class PersistenceService {

    private init() {}

    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatbotDataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    static func saveContext() {
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