//
//  GGPostForm.h
//  TestNetWork
//
//  Created by Static Ga on 13-11-13.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPostForm : NSObject
@property (nonatomic, copy) NSString *name;//Required

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *mimeType;

@end
