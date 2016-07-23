//
//  DataStore.swift
//  SlapChat
//
//  Created by Flatiron School on 7/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    
    var messages:[Message] = []
    var recipients:[Recipient] = []
    
    static let sharedDataStore = DataStore()
    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func fetchData ()
    {
        
        var error:NSError? = nil
        
        let messagesRequest = NSFetchRequest(entityName: "Message")
        let recipientRequest = NSFetchRequest(entityName: "Recipient")
        
        let createdAtSorter = NSSortDescriptor(key: "createdAt", ascending:true)
        
        messagesRequest.sortDescriptors = [createdAtSorter]
        
        do{
            messages = try managedObjectContext.executeFetchRequest(messagesRequest) as! [Message]
            recipients = try managedObjectContext.executeFetchRequest(recipientRequest) as! [Recipient]
        }catch let nserror1 as NSError{
            error = nserror1
            messages = []
            recipients = []
        }
        
        if messages.count == 0 || recipients.count == 0 {
            generateTestData()
        }
    }
    
    func generateTestData() {
        
        let messageOne: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        
        messageOne.content = "Message 1"
        messageOne.createdAt = NSDate()
        
        let messageTwo: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        
        messageTwo.content = "Message 2"
        messageTwo.createdAt = NSDate()
        
        let messageThree: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        
        messageThree.content = "Message 3"
        messageThree.createdAt = NSDate()
        
        let recipientA: Recipient = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: managedObjectContext) as! Recipient
        
        recipientA.name = "Betty"
        recipientA.email = "recipientb@email.com"
        recipientA.phoneNumber = "(845) - 555 - 1313"
        recipientA.twitterHandle = "@recipientB"
        recipientA.messages = [messageOne, messageTwo]
        
        let recipientB: Recipient = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: managedObjectContext) as! Recipient
        
        recipientB.name = "Betty"
        recipientB.email = "recipientb@email.com"
        recipientB.phoneNumber = "(845) - 555 - 1313"
        recipientB.twitterHandle = "@recipientB"
        recipientB.messages = [messageOne, messageTwo]
        
        let recipientC: Recipient = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: managedObjectContext) as! Recipient
        
        recipientC.name = "Betty"
        recipientC.email = "recipientb@email.com"
        recipientC.phoneNumber = "(845) - 555 - 1313"
        recipientC.twitterHandle = "@recipientB"
        recipientC.messages = [messageOne, messageTwo]
        
        
        
        saveContext()
        fetchData()
    }
    
//        let messageOne: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
//        
//        messageOne.content = "Message 1"
//        messageOne.createdAt = NSDate()
//        
//        let messageTwo: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
//        
//        messageTwo.content = "Message 2"
//        messageTwo.createdAt = NSDate()
//        
//        let messageThree: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
//        
//        messageThree.content = "Message 3"
//        messageThree.createdAt = NSDate()
//        
//        let recipientA: Recipient = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: managedObjectContext) as! Recipient
//        
//        recipientA.email = "recipienta@email.com"
//        recipientA.name = "Recipient A"
//        recipientA.phoneNumber = "(845) - 555 - 1212"
//        recipientA.twitterHandle = "@recipientA"
//        recipientA.messages = [messageOne]
//        
//        let recipientB: Recipient = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: managedObjectContext) as! Recipient
//        recipientB.name = "Recipient B"
//        recipientB.email = "recipientb@email.com"
//        recipientB.phoneNumber = "(845) - 555 - 1313"
//        recipientB.twitterHandle = "@recipientB"
//        recipientB.messages = [messageTwo]
//        
//        let recipientC: Recipient = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: managedObjectContext) as! Recipient
//        recipientC.name = "Recipient C"
//        recipientC.email = "recipientc@email.com"
//        recipientC.phoneNumber = "(845) - 555 - 1414"
//        recipientC.twitterHandle = "@recipientC"
//        recipientC.messages = [messageOne, messageTwo, messageThree]
//        saveContext()
//        fetchData()

    
    // MARK: - Core Data stack
    // Managed Object Context property getter. This is where we've dropped our "boilerplate" code.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SlapChat", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    //MARK: Application's Documents directory
    // Returns the URL to the application's Documents directory.
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.FlatironSchool.SlapChat" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
}