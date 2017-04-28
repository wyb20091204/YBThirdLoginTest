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
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
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

- (void)uploadImage:(id)image
                key:(NSString*)key
              token:(NSString*)token
         uploadBase:(NSString*)uploadBase
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSString *URLString = uploadBase;
    
    NSMutableURLRequest *request = [self.manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:@{@"key":key, @"token":token}  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"tmp.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, operation.responseString);
        }
    } failure:failure];
    [op start];
}

-(void) applyImageUpload:(int)type target_id:(int)tid success:(void (^)(NSString* key, NSString* token, NSString* uploadBase, NSString* imageBase))success failure:(void (^)(NSError* err))failure{
    NSLog(@"apply image upload for: %d, id:%d ", type, tid);
    
    NSString *URLString = [NSString stringWithFormat:@"http://gymdev.jiahenghealth.com/imgs/applyUpload"];
    NSDictionary* param = @{@"type":@(type), @"target_id":@(tid)};
    [self POST:URLString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data = responseObject[@"result"][@"data"];
        NSLog(@"response data: %@", data);
        if(data!=nil){
            NSString* key = (NSString*) [data valueForKey:@"key"];
            NSString* token = (NSString*) [data valueForKey:@"token"];
            NSString* uploadBase = (NSString*) [data valueForKey:@"uploadBase"];
            NSString* imageBase = (NSString*) [data valueForKey:@"imageBase"];
            if(success){
                success(key, token, uploadBase, imageBase);
            }
        }else{
//            failure(500);// net work accsess full
            NSLog(@"网络请求错误");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [operation.responseObject[@"result"][@"status"] integerValue]
        failure(error);
    }];
}

@end
