//
//  NetWork.m
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/24.
//  Copyright © 2017年 一波. All rights reserved.
//

#import "NetWork.h"

@interface NetWork ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@end


@implementation NetWork
+ (NetWork *)network{
    static dispatch_once_t onceToken;
    static NetWork *network;
    dispatch_once(&onceToken, ^{
        network = [[NetWork alloc] init];
    });
    
    return network;
}
- (instancetype)init {
    if (self = [super init]) {
        self.manager = [AFHTTPRequestOperationManager manager];
        [self.manager.requestSerializer setTimeoutInterval:30];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//        self.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        self.manager.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self.manager GET:URLString parameters:parameters success:success failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
        if (failure) {
            failure(operation, error);
        }
    }];
}



- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    return [self.manager POST:URLString parameters:parameters success:success failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"URI: %@, Param:%@, error, %@", URLString, parameters, error);
        if (failure) {
            failure(operation, error);
        }
    }];
}
@end
