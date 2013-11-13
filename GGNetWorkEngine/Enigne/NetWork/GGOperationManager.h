//
//  GGOperationManager.h
//  TestNetWork
//
//  Created by Static Ga on 13-11-7.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface GGOperationManager : AFHTTPRequestOperationManager
+ (instancetype)manager;
- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method path:(NSString *)path;
@end
