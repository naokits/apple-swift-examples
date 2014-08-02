//
//  ViewController.swift
//  Overdub
//
//  Created by Naoki Tsutsui on 2014/06/08.
//  Copyright (c) 2014 Naoki Tsutsui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var audioController: AudioController = AudioController()
    var recorder: AERecorder = AERecorder()

                            
    @IBOutlet var recordButton : UIButton
    @IBOutlet var playButton : UIButton
    
    @IBAction func pressedRecordButton(sender : AnyObject) {
        if recordButton.selected {
            recordButton.selected = false
            audioController.endRecording()
        } else {
            recordButton.selected = true
            audioController.beginRecording()
        }
    }
    
    @IBAction func pressedPlayButton(sender : AnyObject) {
        if playButton.selected {
            playButton.selected = false
        } else {
            playButton.selected = true
            buttonAction()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        recordButton.setTitle("Record", forState: UIControlState.Normal)
        recordButton.setTitle("Stop", forState: UIControlState.Selected)

        playButton.setTitle("Play", forState: UIControlState.Normal)
        playButton.setTitle("Stop", forState: UIControlState.Selected)

        setupAudioEngine()

        //        controller.hoge()
//        controller.hogehoge()
        NSLog("%@", "test")
        buttonAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupAudioEngine() {
        let adesc = AEAudioController.nonInterleaved16BitStereoAudioDescription
        let audioController: AEAudioController! = AEAudioController(audioDescription: adesc(),  inputEnabled: true)
        audioController.preferredBufferDuration = 0.005
        audioController.start(nil)
    }
    
    func buttonAction() {
        var sum = 10
        var alert = UIAlertController(title: "Title", message: String(format: "Result = %i", sum), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func viewSample() {
        
        var label = UILabel(frame: self.view.bounds)
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(36)
        label.text = "Hello, Swift"
        self.view.addSubview(label)
        

        var image     = UIImage(named: "swift-hero.png")
        var imageView = UIImageView(frame: CGRectMake((CGRectGetWidth(self.view.bounds) - image.size.width) / 2.0, 120.0, image.size.width, image.size.height))
        imageView.image = image
        self.view.addSubview(imageView)
    }

    
    func stopRecording() {
        recorder.finishRecording()
//        self.audioController
    }
    
    func record() {
        
        
        /*
        if ( _recorder ) {
        [_recorder finishRecording];
        [_audioController removeOutputReceiver:_recorder];
        [_audioController removeInputReceiver:_recorder];
        self.recorder = nil;
        _recordButton.selected = NO;
        } else {
        self.recorder = [[AERecorder alloc] initWithAudioController:_audioController];
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.aiff"];
        NSError *error = nil;
        if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileAIFFType error:&error] ) {
        //            [[[UIAlertView alloc] initWithTitle:@"Error"
        //                                         message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
        //                                        delegate:nil
        //                               cancelButtonTitle:nil
        //                               otherButtonTitles:@"OK", nil] show];
        self.recorder = nil;
        return;
        }
        
        _recordButton.selected = YES;
        
        [_audioController addOutputReceiver:_recorder];
        [_audioController addInputReceiver:_recorder];
        }
        }
        */

    }
}
