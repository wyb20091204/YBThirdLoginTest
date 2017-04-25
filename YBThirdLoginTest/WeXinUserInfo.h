//
//  WeXinUserInfo.h
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/25.
//  Copyright © 2017年 一波. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KEYFORUSER @"KEYFORUSER"

@interface WeXinUserInfo : NSObject
// 普通用户的标识，对当前开发者帐号唯一
@property (nonatomic) NSString *openid;
@property (nonatomic) NSString *nickname;
// 普通用户性别，1为男性，2为女性
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic) NSString *province; // 省份
@property (nonatomic) NSString *city;     // 城市
@property (nonatomic) NSString *country;  // 国家 如中国为CN
// 用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空
@property (nonatomic) NSString *headimgurl;
//用户特权信息，json数组，如微信沃卡用户为（chinaunicom）
@property (nonatomic) NSString *privilege;
// 用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
@property (nonatomic) NSString *unionid;

@property (nonatomic) NSString *language;

@end
