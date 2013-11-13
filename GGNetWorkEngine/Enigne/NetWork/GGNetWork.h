//
//  GGNetWork.h
//  TestNetWork
//
//  Created by Static Ga on 13-11-7.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGTypeDef.h"

@interface GGNetWork : NSObject

/**
 *  Http Post
 *
 *  @param path        Http path,for example:Base URL is http://example.com/v1/, the path is login? or /login.
 *  @param par         parameters to post.
 *  @param sucessBlock sucess block to transfer object.
 *  @param failedBlock failed block to transfer error.
 */
+ (void)postHttp:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock
          failed:(GGFailedBlock)failedBlock;

/**
 *  Http Post Mutible File/Data to Server
 *
 *  @param path        Http Path
 *  @param par         parameters to post
 *  @param fileDataArr An array contains file(GGPostFile) or data(GGPostData),formData will append those.
 *  @param sucessBlock sucess block to transfer object.
 *  @param failedBlock failed block to transfer error.
 */
+ (void)postMutibleHttp:(NSString *)path parameters:(NSDictionary *)par partsForm:(NSArray *)fileDataArr sucess:(GGSucessBlock)sucessBlock
                 failed:(GGFailedBlock)failedBlock;

/**
 *  Http Get
 *
 *  @param path        Http path.
 *  @param par         parameters. (url form)
 *  @param sucessBlock sucess block to transfer object.
 *  @param failedBlock failed block to transfer error.
 */
+ (void)getHttp:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock
         failed:(GGFailedBlock)failedBlock;

/**
 *  Cancel a http request
 *
 *  @param path   the request path to cancel
 *  @param method GET || POST || DELETE || PATCH || HEAD || PUT
 */
+ (void)cancelURL:(NSString *)path forMethod:(kHttpMethod)method;
@end
