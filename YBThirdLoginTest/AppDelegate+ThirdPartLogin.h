//
//  AppDelegate+ThirdPartLogin.h
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/25.
//  Copyright © 2017年 一波. All rights reserved.
//

#import "AppDelegate.h"




#import <WXApi.h>
#define kWeiXinAppKey @"wx539fba18a39b78e1"
#define kWeiXinAppSecret @"eed6f0dc893c750c5d1022c2d2c0916d"

#import <TencentOpenAPI/TencentOAuth.h>
#define kQQAppID @"1106118074"


@interface AppDelegate (ThirdPartLogin)<WXApiDelegate>

- (void)registToWeChat;

@end
