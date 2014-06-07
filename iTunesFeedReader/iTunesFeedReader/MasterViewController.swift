//
//  MasterViewController.swift
//  iTunesFeedReader
//
//  Created by Naoki Tsutsui on 2014/06/05.
//  Copyright (c) 2014年 Naoki Tsutsui. All rights reserved.
//

import UIKit
//import iTunesFeedClient


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
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        fetchFeeds()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        fetchFeeds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let object = objects[indexPath.row] as NSDictionary
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

    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 100
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        let object : AnyObject = objects[indexPath.row] as AnyObject

        cell.textLabel.text = object.valueForKeyPath("title.label") as NSString!
        cell.textLabel.font = UIFont.systemFontOfSize(14.0)
        cell.textLabel.numberOfLines = 0
        cell.detailTextLabel.text = object.valueForKeyPath("category.attributes.label") as NSString

        let images = object["im:image"] as NSArray
        let imgURL: NSURL = NSURL(string: images[2].valueForKeyPath("label") as NSString)
        cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        cell.imageView.setImageWithURL(imgURL, placeholderImage: UIImage(named: "empty.png"))
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: self)
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
            var entries = results.valueForKeyPath("feed.entry") as NSArray
            if self.objects == nil {
                self.objects = NSMutableArray()
            }

            self.objects = entries.mutableCopy() as NSMutableArray
            self.tableView.reloadData()
            
            // 内容確認のためにコンソールに表示
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
