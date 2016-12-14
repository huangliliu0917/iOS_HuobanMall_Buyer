//
//  UserLoginTool.m
//  fanmore---
//
//  Created by lhb on 15/5/21.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import "UserLoginTool.h"
#import "AFNetworking.h"
#import <MKNetworkKit.h>


@interface UserLoginTool()

@end



@implementation UserLoginTool

+ (void)loginRequestGet:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success(responseObject);
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
    
    
//    [manager GET:urlStr parameters:params success:^void(AFHTTPRequestOperation * request, id json) {
//       success(json);
//        NSLog(@"%@",request);
//    } failure:^void(AFHTTPRequestOperation * reponse, NSError * error) {
//        NSLog(@"%@",reponse);
//        failure(error);
//    }];
}

+ (void)loginRequestDateGet:(NSString *)urlStr parame:(NSMutableDictionary *)params downloadSuccess:(void (^)(AFHTTPRequestSerializer *operation, id responseObject))success downloadFailure:(void (^)(AFHTTPRequestSerializer *operation, NSError *error))failure progress:(void (^)(float progress))progress{
    
//    NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/update.zip"];
//    //下载附件
//    NSURL *url = [[NSURL alloc] initWithString:urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    AFHTTPRequestSerializer * operation = [[AFHTTPRequestSerializer alloc] initWithRequest:request];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        float p = (float)totalBytesRead / totalBytesExpectedToRead;
//        progress(p);
//    }];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        success(operation,responseObject);
//        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        failure(operation,error);
//    }];
//    [operation start];
   
}




+ (void)loginRequestPost:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
}

+ (void)loginRequestPostWithFile:(NSString *)urlStr parame:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure withFileKey:(NSString *)key{
    

    
    //   AFHTTPRequestOperationManager * manager  = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary * paramsOption = [NSMutableDictionary dictionary];
    
     if (params != nil) {
        [paramsOption addEntriesFromDictionary:params];
    }
    //
    
    NSData *data = [[paramsOption objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [paramsOption removeObjectForKey:key];
    //
    paramsOption[@"profiledata"] = str;
    
    paramsOption = [NSDictionary asignWithMutableDictionary:paramsOption];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:MainUrlMK customHeaderFields:nil];
    
    MKNetworkOperation *op = [engine operationWithPath:urlStr params:paramsOption httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        success(completedOperation.responseJSON);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        failure(error);
    }];
    
    [engine enqueueOperation:op];
}

@end
