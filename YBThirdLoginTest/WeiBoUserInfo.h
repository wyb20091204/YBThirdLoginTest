//
//  WeiBoUserInfo.h
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/26.
//  Copyright © 2017年 一波. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KERFOWEIBOUSER @"KEYFORWEIBOUSER"

@interface WeiBoUserInfo : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *screen_name; // 两个name 值一样
@property (nonatomic) NSString *Userdescription; // 个性签名
@property (nonatomic) NSString *location;    // 地址
@property (nonatomic) NSString *idstr;       // 用户idstring
@property (nonatomic,assign) NSInteger wbUserID; // 用户id
@property (nonatomic) NSString *avatar_hd;
@end
