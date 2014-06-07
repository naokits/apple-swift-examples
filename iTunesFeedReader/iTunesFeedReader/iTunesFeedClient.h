//
//  iTunesFeedClient.h
//  iTunesFeedClient
//
//  Created by Naoki Tsutsui on 2014/01/25.
//  Copyright (c) 2014年 Naoki Tsutsui. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^completionBlock)(NSDictionary *results, NSError *error);

@interface iTunesFeedClient : AFHTTPSessionManager

+ (iTunesFeedClient *)sharedClient;

- (NSURLSessionDataTask *)fetchTop10Music:(completionBlock)completion;

@end
