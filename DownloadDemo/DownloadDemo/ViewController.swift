//
//  ViewController.swift
//  DownloadDemo
//
//  Created by Naoki Tsutsui on 2014/08/07.
//  Copyright (c) 2014 Naoki Tsutsui. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDownloadDelegate {
                            
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pdfView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var data: NSData = NSData()
    var counter: Int64 = 0
    
    var downloadTask: NSURLSessionDownloadTask = NSURLSessionDownloadTask()
    
    
    //====================================================================================
    // MARK: - Action
    //====================================================================================
    
    // リジュームに対応しないダウンロード
    @IBAction func tappedDownloadButton(sender: AnyObject) {
        println("ダウンロードボタンがタップされた")
        let url = NSURL.URLWithString("http://primer.ph/cms/archives/freepaper/vol77_img02.pdf") as NSURL
        let request: NSURLRequest = NSURLRequest(URL:url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        self.downloadTask = session.downloadTaskWithURL(url)
        self.downloadTask.resume()
        
        self.downloadButton.enabled = false
        self.cancelButton.enabled = true
        self.pdfView.hidden = true
    }
    
    // キャンセル
    @IBAction func tappedCancelButton(sender: AnyObject) {
        println("キャンセルボタンがタップされた")
        self.downloadButton.enabled = true
        self.cancelButton.enabled = false
        self.progressView.progress = 0.0;
    }
    
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let data : NSData = NSData.dataWithContentsOfURL(location, options: nil, error: &error)
        // ここで表示
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
        
        if ((++self.counter % 50) == 0) {
            let writedSize = Float((Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)))
            //            println("読み込み済: \(bytesWritten) : \(totalBytesWritten) : \(totalBytesExpectedToWrite) : \(writedSize) * 100")
            self.progressView.progress = writedSize
        }
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
        if error != nil {
            if error.code == -999 {
                println("キャンセルされた")
                downloadTask.cancel()
            } else if error.code == -1005 {
                println("The operation couldn’t be completed.")
            } else {
                println(error)
            }
        } else {
            println("正常にセッションが終了")
        }
    }
}

