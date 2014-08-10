//
//  ViewController.swift
//  AnimatedImageDemo
//
//  Created by Naoki Tsutsui on 2014/08/09.
//  Copyright (c) 2014 Naoki Tsutsui. All rights reserved.
//

// バンドルにある複数の画像をアニメーション表示する

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.imageView.image = UIImage.animatedImageWithImages(self.frameImages(), duration: 2.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func frameImages() -> NSArray {
        
        let images: NSArray = [UIImage(named: "1.png"),
                               UIImage(named: "2.png"),
                               UIImage(named: "3.png"),
                               UIImage(named: "4.png"),
                               UIImage(named: "5.png"),
                               UIImage(named: "6.png"),
        ]

        return images
    }
}

