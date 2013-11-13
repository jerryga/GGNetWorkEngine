//
//  GGNetWork.m
//  TestNetWork
//
//  Created by Static Ga on 13-11-7.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#import "GGNetWork.h"
#import "AFHTTPRequestOperationManager.h"
#import "GGOperationManager.h"
#import "GGPost.h"

#define kBaseURL @""

@implementation GGNetWork

static NSString* form_urlencode_HTTP5_String(NSString* s) {
    CFStringRef charactersToLeaveUnescaped = CFSTR(" ");
    CFStringRef legalURLCharactersToBeEscaped = CFSTR("!$&'()+,/:;=?@~");
    
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 kCFAllocatorDefault,
                                                                                 (__bridge CFStringRef)s,
                                                                                 charactersToLeaveUnescaped,
                                                                                 legalURLCharactersToBeEscaped,
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

static NSString* form_urlencode_HTTP5_Parameters(NSDictionary* parameters)
{
    NSMutableString* result = [[NSMutableString alloc] init];
    BOOL isFirst = YES;
    for (NSString* name in parameters) {
        if (!isFirst) {
            [result appendString:@"&"];
        }
        isFirst = NO;
        assert([name isKindOfClass:[NSString class]]);
        NSString* value = parameters[name];
        assert([value isKindOfClass:[NSString class]]);
        
        NSString* encodedName = form_urlencode_HTTP5_String(name);
        NSString* encodedValue = form_urlencode_HTTP5_String(value);
        
        [result appendString:encodedName];
        [result appendString:@"="];
        [result appendString:encodedValue];
    }
    
    return [result copy];
}

static NSURL* makeURLWithPath(NSString *path)
{
    NSURL *url = nil;
    if (path && ![path isEqualToString:@""]) {
        url = [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:kBaseURL]];
    }
    
    return url;
}

+ (void)postHttp:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock
          failed:(GGFailedBlock)failedBlock{
    
    GGOperationManager *manager = [GGOperationManager manager];
    NSString *urlStr = makeURLWithPath(path).absoluteString;
    
    [manager POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Handle the ResponseObject,for example, parse 'status',handle data by switch status.
        //after handled these, transfer responseObject to next by block
        if (sucessBlock) {
            sucessBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //show alert
        if (failedBlock) {
            failedBlock(error.localizedDescription);
        }
    }];
}

+ (void)postMutibleHttp:(NSString *)path parameters:(NSDictionary *)par partsForm:(NSArray *)fileDataArr sucess:(GGSucessBlock)sucessBlock
          failed:(GGFailedBlock)failedBlock {
    
    GGOperationManager *manager = [GGOperationManager manager];
    NSString *urlStr = makeURLWithPath(path).absoluteString;

    [manager POST:urlStr parameters:par constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (fileDataArr && fileDataArr.count > 0) {
            [fileDataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[GGPostFile class]]) {
                    GGPostFile *file = (GGPostFile *)obj;
                    if (file.mimeType) {
                        [formData appendPartWithFileURL:file.fileURL name:file.name fileName:file.fileName mimeType:file.mimeType error:nil];
                    }else {
                        [formData appendPartWithFileURL:file.fileURL name:file.fileName error:nil];
                    }
                }else if ([obj isKindOfClass:[GGPostData class]]) {
                    GGPostData *data = (GGPostData *)obj;
                    if (data.mimeType && data.fileName) {
                        [formData appendPartWithFileData:data.data name:data.name fileName:data.fileName mimeType:data.mimeType];
                    }else {
                        [formData appendPartWithFormData:data.data name:data.name];
                    }
                }
            }];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sucessBlock) {
            sucessBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error.localizedDescription);
        }
    }];
}

+ (void)getHttp:(NSString *)path parameters:(NSDictionary *)par sucess:(GGSucessBlock)sucessBlock
         failed:(GGFailedBlock)failedBlock {
    GGOperationManager *manager = [GGOperationManager manager];
    NSString *urlStr = makeURLWithPath(path).absoluteString;

    [manager GET:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sucessBlock) {
            sucessBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error.localizedDescription);
        }
    }];
}

+ (void)cancelURL:(NSString *)path forMethod:(kHttpMethod)method{
    NSString *methodStr = @"";
    switch (method) {
        case kHttpPostMethod:
        {
            methodStr = @"POST";
        }
            break;
        case kHttpGetMethod:
        {
            methodStr = @"GET";
        }
            break;
        default:
            break;
    }
    GGOperationManager *manager = [GGOperationManager manager];
    [manager cancelAllHTTPOperationsWithMethod:methodStr path:path];
}
@end
