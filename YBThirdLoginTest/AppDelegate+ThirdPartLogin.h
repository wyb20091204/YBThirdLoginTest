//
//  AppDelegate+ThirdPartLogin.h
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/25.
//  Copyright © 2017年 一波. All rights reserved.
//

#import "AppDelegate.h"

#import <WXApi.h>
#define kWeiXinAppKey @"kWeiXinAppKey"
#define kWeiXinAppSecret @"kWeiXinAppSecret"

#import <TencentOpenAPI/TencentOAuth.h>
#define kQQAppID @"kQQAppID"

#import <WeiboSDK.h>
#define kWeiBoAppID @"kWeiBoAppID"
#define kWeiBoAppKey @"kWeiBoAppKey"
#define kWeiBoAppSecret @"kWeiBoAppSecret"
#define kWeiBoRedirectURI  @"https://api.weibo.com/oauth2/default.html"


@interface AppDelegate (ThirdPartLogin)<WXApiDelegate,WeiboSDKDelegate>

- (void)registToWeChat;
- (void)registToWeiBo;

@end
