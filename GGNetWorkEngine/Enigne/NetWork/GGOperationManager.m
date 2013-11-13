//
//  GGOperationManager.m
//  TestNetWork
//
//  Created by Static Ga on 13-11-7.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#import "GGOperationManager.h"

@implementation GGOperationManager

+ (instancetype)manager {
    static GGOperationManager *operationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef kBaseURL
        operationManager = [[GGOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
#else
        operationManager = [[GGOperationManager alloc] initWithBaseURL:nil];
#endif
        
    });
    
    return operationManager;
}


- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method
                                     path:(NSString *)path
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    NSString *pathToBeMatched = [[[self.requestSerializer requestWithMethod:(method ? : @"GET") URLString:path parameters:nil] URL] path];

#pragma clang diagnostic pop
    for (NSOperation *operation in [self.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        
        BOOL hasMatchingMethod = !method || [method isEqualToString:[[(AFHTTPRequestOperation *)operation request] HTTPMethod]];
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        NSLog(@"ori %@",[[[(AFHTTPRequestOperation *)operation request] URL] path]);
        NSLog(@"pat %@",pathToBeMatched);
        if (hasMatchingMethod && hasMatchingPath) {
            NSLog(@"foundOperation");
            [operation cancel];
        }
    }
}

@end
