//
//  MasterViewController.swift
//  iTunesFeedReader
//
//  Created by Naoki Tsutsui on 2014/06/05.
//  Copyright (c) 2014年 Naoki Tsutsui. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects = NSMutableArray()


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        self.fetchFeeds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        if objects == nil {
            objects = NSMutableArray()
        }
        objects.insertObject(NSDate.date(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // #pragma mark - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let object = objects[indexPath.row] as NSDate
            (segue.destinationViewController as DetailViewController).detailItem = object
        }
    }

    //=============================================================================
    // #pragma mark - Table View
    //=============================================================================

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row] as NSDate
        cell.textLabel.text = object.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    // #pragma mark - Utility Methods
    
    // フィードを取得する
    func fetchFeeds() {
        let client = iTunesFeedClient.sharedClient()

        client.fetchTop10Music({(results, error) in
            if (error) {
                println(error)
                return
            }
            let entries = results.valueForKeyPath("feed.entry") as NSArray
            for entry : AnyObject in entries {
                println(entry.valueForKeyPath("category.attributes.im:id"))
                println(entry.valueForKeyPath("category.attributes.label"))
                println(entry.valueForKeyPath("category.attributes.scheme"))
                println(entry.valueForKeyPath("category.attributes.term"))
                println("--")
                println(entry.valueForKeyPath("id.attributes.im:id"))
                println(entry.valueForKeyPath("id.label"))
                println("--")
                println(entry.valueForKeyPath("title.label"))
                println(entry.valueForKeyPath("category.attributes.label"))
                println("--")
                println(entry.valueForKeyPath("im:artist.label"))
                println(entry.valueForKeyPath("im:artist.attributes.href"))
                println("--")
                println(entry.valueForKeyPath("im:contentType.attributes.label"))
                println(entry.valueForKeyPath("im:contentType.attributes.term"))
                println("--")
                println(entry.valueForKeyPath("im:contentType.im:contentType.attributes.label"))
                println(entry.valueForKeyPath("im:contentType.im:contentType.attributes.term"))
                println("--")
                println(entry.valueForKeyPath("rights.label"))
                println("--")
                println(entry.valueForKeyPath("link.attributes.href"))
                println(entry.valueForKeyPath("link.attributes.rel"))
                println(entry.valueForKeyPath("link.attributes.type"))
                println("--")
                println(entry.valueForKeyPath("im:releaseDate.attributes.label"))
                println(entry.valueForKeyPath("im:releaseDate.label"))
                println("--")
                println(entry.valueForKeyPath("im:itemCount.label"))
                println(entry.valueForKeyPath("im:name.label"))
                println("--")
                println(entry.valueForKeyPath("im:price.label"))
                println(entry.valueForKeyPath("im:price.attributes.amount"))
                println(entry.valueForKeyPath("im:price.attributes.currency"))
                
                let images = entry["im:image"] as NSArray
                for image: AnyObject in images {
                    println(image.objectForKey("label"))
                    println(image.valueForKeyPath("attributes.height"))
                }
                
                println("------------------------------------")
            }
        })
    }
}
