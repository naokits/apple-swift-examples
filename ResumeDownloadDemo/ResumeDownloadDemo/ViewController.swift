//
//  ViewController.swift
//  ResumeDownloadDemo
//
//  Created by Naoki Tsutsui on 2014/08/02.
//  Copyright (c) 2014年 Naoki Tsutsui. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pdfView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var downloadSession: NSURLSession!
    var downloadTask: NSURLSessionDownloadTask!
    var resumeData: NSData! = nil
    var counter: Int64 = 0

    let urlString = "http://primer.ph/cms/archives/freepaper/vol77_img02.pdf"
//    let urlString = "https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSessionDownloadTask_class/NSURLSessionDownloadTask_class.pdf"
    let downloadIdentifier = "myDownloadIdentifier"

    //====================================================================================
    // MARK: - Lifecycle
    //====================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.cancelButton.enabled = false
        self.progressView.tintColor = UIColor.blueColor()
        self.progressView.progress = 0.0
        
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //====================================================================================
    // MARK: - Action
    //====================================================================================
    
    @IBAction func tappedDownloadButton(sender: AnyObject) {
        println("ダウンロードボタンがタップされた")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.pdfView.hidden = true
        
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(self.downloadIdentifier)
        // delegateQueueにnilを指定すると、適切なキューが利用されるらしい
        self.downloadSession = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        self.downloadSession.getTasksWithCompletionHandler({ (dataTasks, uploadTasks, downloadTasks) -> Void in
            if  downloadTasks.count > 0 {
                let alertController = UIAlertController(title: "メッセージ", message: "ダウンロードを再開中です", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    println("OKボタンがタップされた")
                })
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)

                for task in downloadTasks {
                    println("残タスク: \(task.description)")
                    // ダウンロード途中のタスクをセットする
                    self.downloadTask = task as NSURLSessionDownloadTask
                }
            } else {
                println("待機中のタスクはありません")
                let url = NSURL.URLWithString(self.urlString) as NSURL
                let request: NSURLRequest = NSURLRequest(URL:url)
                self.downloadTask = self.downloadSession.downloadTaskWithURL(url)
            }
            self.downloadTask.resume()
        })
        
        self.downloadButton.enabled = false
        self.cancelButton.enabled = true
    }
    
    @IBAction func tappedCancelButton(sender: AnyObject) {

        let alertController = UIAlertController(title: "", message: "どうしますか？", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "ダウンロードを終了", style: .Default, handler: { (action) -> Void in
            // 実行後に didCompleteWithError が呼ばれる
            self.downloadTask.cancelByProducingResumeData({resumeData in
                println("途中までのデータ:\(resumeData.length)")
                if resumeData.length > 0 {
                    println("途中までダウンロードしたデータ:\(resumeData.length)")
                    self.resumeData = resumeData;
                } else {
                    self.resumeData = nil
                }
            })
        })
        let suspendAction = UIAlertAction(title: "ダウンロードを一時停止", style: .Default, handler: { (action) -> Void in
            self.downloadTask.suspend()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(suspendAction)
        self.presentViewController(alertController, animated: true, completion: { () in
            println("アラートが表示された直後")
        })

        self.downloadButton.enabled = true
        self.cancelButton.enabled = false
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

    }
    
    //====================================================================================
    // MARK: - NSURLSessionDownloadDelegate
    //====================================================================================
    
    /* Sent when a download task that has completed a download.  The delegate should
    * copy or move the file at the given location to a new location as it will be
    * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
    * still be called.
    */
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didFinishDownloadingToURL location: NSURL!) {
        println("ダウンロード完了: \(location)")
        self.downloadButton.enabled = true
        self.cancelButton.enabled = false
        
        var error : NSError? = nil
        let data : NSData = NSData.dataWithContentsOfURL(location, options: .DataReadingMappedIfSafe, error: &error)

        if (error != nil) {
            println(error)
        } else {
            self.pdfView.loadData(data, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: nil)
            self.pdfView.hidden = false
        }
    }
    
    /* Sent periodically to notify the delegate of download progress. */
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // ダウンロードの進行状況が定期的に通知されます
        let writedSize = Float((Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)))
        dispatch_async(dispatch_get_main_queue(), {
            if ((++self.counter % 3) == 0) {
                println("読み込み済: \(bytesWritten) : \(totalBytesWritten) : \(totalBytesExpectedToWrite) : \(writedSize * 100)")
                self.progressView.progress = writedSize
            }
            });
    }
    
    /* Sent when a download has been resumed. If a download failed with an
    * error, the -userInfo dictionary of the error will contain an
    * NSURLSessionDownloadTaskResumeData key, whose value is the resume
    * data.
    */
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64)
    {
        println("リジューム:\(fileOffset) : \(expectedTotalBytes)")
    }
    
    //====================================================================================
    // MARK: - NSURLSessionDataDelegate
    //====================================================================================
    
    
    /* An HTTP request is attempting to perform a redirection to a different
    * URL. You must invoke the completion routine to allow the
    * redirection, allow the redirection with a modified request, or
    * pass nil to the completionHandler to cause the body of the redirection
    * response to be delivered as the payload of this request. The default
    * is to follow redirections.
    *
    * For tasks in background sessions, redirections will always be followed and this method will not be called.
    */
    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, willPerformHTTPRedirection response: NSHTTPURLResponse!, newRequest request: NSURLRequest!, completionHandler: ((NSURLRequest!) -> Void)!) {
        NSLog("willPerformHTTPRedirection")
    }
    
    /* The task has received a request specific authentication challenge.
    * If this delegate is not implemented, the session specific authentication challenge
    * will *NOT* be called and the behavior will be the same as using the default handling
    * disposition.
    */
    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didReceiveChallenge challenge: NSURLAuthenticationChallenge!, completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void)!) {
        NSLog("didReceiveChallenge")
    }
    
    /* Sent if a task requires a new, unopened body stream.  This may be
    * necessary when authentication has failed for any request that
    * involves a body stream.
    */
    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, needNewBodyStream completionHandler: ((NSInputStream!) -> Void)!) {
        NSLog("needNewBodyStream")
    }
    
    /* Sent periodically to notify the delegate of upload progress.  This
    * information is also available as properties of the task.
    */
    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        NSLog("didSendBodyData")
    }
    
    /* Sent as the last message related to a specific task.  Error may be
    * nil, which implies that no error occurred and this task is complete.
    */
    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didCompleteWithError error: NSError!) {
        NSLog("セッションの終了")
        if (error != nil) {
            println(error)
            if error.code == -999 {
                println("キャンセルされた")
            }
            session.invalidateAndCancel()
        } else {
            session.finishTasksAndInvalidate()
        }
        
        self.progressView.progress = 0.0
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

