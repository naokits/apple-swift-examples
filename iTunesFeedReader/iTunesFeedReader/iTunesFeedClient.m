//
//  iTunesFeedClient.m
//  iTunesFeedClient
//
//  Created by Naoki Tsutsui on 2014/01/25.
//  Copyright (c) 2014年 Naoki Tsutsui. All rights reserved.
//

#import "iTunesFeedClient.h"

/// Endpoint
NSString * const kBaseEndPoint = @"https://itunes.apple.com/";
// Top Album
//NSString * const kFeedURL = @"https://itunes.apple.com/jp/rss/topalbums/limit=10/json";
// Top Song
NSString * const kFeedURL = @"https://itunes.apple.com/jp/rss/topsongs/limit=20/json";
/// User Agent
NSString * const RXiTunesAPIClientUserAgent = @"iTunesFeedClient iOS 0.1.0";

/// Cache
NSInteger const kMemoryCapacity = (10 * 1024 * 1024);
NSInteger const kDiskCapacity = (50 * 1024 * 1024);

@implementation iTunesFeedClient

+ (iTunesFeedClient*)sharedClient
{
    static iTunesFeedClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:kBaseEndPoint];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setHTTPAdditionalHeaders:@{@"User-Agent" : RXiTunesAPIClientUserAgent}];
        NSURLCache *cache;
        cache = [[NSURLCache alloc] initWithMemoryCapacity:kMemoryCapacity
                                              diskCapacity:kDiskCapacity
                                                  diskPath:nil];
        [config setURLCache:cache];
        
        _sharedClient = [[iTunesFeedClient alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}


- (NSURLSessionDataTask*)fetchTop10Music:(completionBlock)completion
{    
    NSURLSessionDataTask *task;
    task = [self GET:kFeedURL
          parameters:nil
             success:^(NSURLSessionDataTask *task, id responseObject) {

                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
                 if (httpResponse.statusCode == 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         completion(responseObject, nil); });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         completion(nil, nil); });
                     NSLog(@"Received: %@", responseObject);
                     NSLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
                 }
             }
             failure:^(NSURLSessionDataTask * task, NSError * error) {
                 dispatch_async(dispatch_get_main_queue(), ^{ completion(nil, error); });
             }];
    
    return task;
}

@end
