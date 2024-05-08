//
//  PersistenceController.swift
//  Appointments
//
//  Created by mahesh lad on 26/04/2024.
//

import CoreData

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    
    init() {
        container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Container load failed: \(error)")
            }
        }
    }
    
    var managedObjectModel: NSManagedObjectModel? {
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd") else {
            fatalError("Failed to find data model")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        
        return mom
    }
}
