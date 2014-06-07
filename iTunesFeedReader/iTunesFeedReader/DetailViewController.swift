//
//  DetailViewController.swift
//  iTunesFeedReader
//
//  Created by Naoki Tsutsui on 2014/06/05.
//  Copyright (c) 2014年 Naoki Tsutsui. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var textView : UITextView!

    var detailItem: NSDictionary? {
        didSet {
            // Update the view.
            println("値がセットされた: \(detailItem)")
        }
    }

    func configureView() {
        println("コンフィグ")
        // Update the user interface for the detail item.
        if let detail: NSDictionary = self.detailItem {
            if textView {
                let tv = textView!
                
                let description = self.detailItem.description as NSString
                let cDescription = description.cStringUsingEncoding(NSUTF8StringEncoding)
                let utf8Description = NSString.stringWithCString(cDescription, encoding: NSNonLossyASCIIStringEncoding)
                textView.text = utf8Description
            } else {
                println("nilではいけない")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (detailItem) {
            self.configureView()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

