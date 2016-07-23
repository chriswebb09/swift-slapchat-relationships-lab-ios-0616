//
//  RecipientTableViewController.swift
//  SlapChat
//
//  Created by Christopher Webb-Orenstein on 7/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class RecipientTableViewController: UITableViewController {
    var managedRecipientObjects: [Recipient] = []
    let dataStore = DataStore.sharedDataStore
    var eachRecipient: Recipient?
    
    
   //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataStore.fetchData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        dataStore.fetchData()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.recipients.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        
        self.eachRecipient = dataStore.recipients[indexPath.row]
        //self.messages = eachRecipient!.messages.allObjects as! [Message]
        if let recipientName = self.eachRecipient!.name {
            cell.textLabel?.text = recipientName
        }
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destinationViewController as? MessageTableViewController
        let selectedRecipient = dataStore.recipients[tableView.indexPathForSelectedRow!.row]
        destinationVC?.managedMessageObjects = selectedRecipient.messages?.allObjects as! [Message]
        
    }
}
//        var messageVC = segue.destinationViewController as! MessageTableViewController {
//            Mes
//        }//MessageTableViewController.destinationViewController
//        


