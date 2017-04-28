//
//  NetWork.h
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/24.
//  Copyright © 2017年 一波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface NetWork : NSObject
+ (NetWork *)network;
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void)uploadImage:(id)image
                key:(NSString*)key
              token:(NSString*)token
         uploadBase:(NSString*)uploadBase
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void) applyImageUpload:(int)type target_id:(int)tid success:(void (^)(NSString* key, NSString* token, NSString* uploadBase, NSString* imageBase))success failure:(void (^)(NSError* err))failure;



@end
