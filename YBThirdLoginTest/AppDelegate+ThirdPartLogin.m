//
//  AppDelegate+ThirdPartLogin.m
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/25.
//  Copyright © 2017年 一波. All rights reserved.
//

#import "AppDelegate+ThirdPartLogin.h"

#import "NetWork.h"
#import "WeXinUserInfo.h"
#import "WeiBoUserInfo.h"


@implementation AppDelegate (ThirdPartLogin)

- (void)registToWeChat{
    [WXApi registerApp:kWeiXinAppKey];
}

- (void)registToWeiBo{
    
#ifdef DEBUG
    [WeiboSDK enableDebugMode:YES];
#endif
    [WeiboSDK registerApp:kWeiBoAppKey];
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    if([[url scheme] hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    } else if([[url scheme] hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    if([[url scheme] hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    } else if([[url scheme] hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
}

// ios 9 以前
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if([[url scheme] hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    } else if([[url scheme] hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
}



#pragma mark   -------------  微信部分 ------------------------

// 从微信切换到第三方程序
- (void)onReq:(BaseReq *)req
{
    NSLog(@"onReq");
}

// 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面
- (void)onResp:(BaseResp *)resp{
    NSLog(@"回调处理");
    
    // 处理 分享请求 回调
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                [self showAlertWithmessage:@"分享成功"];
                break;
                
            default:
                [self showAlertWithmessage:@"分享失败"];
                break;
        }
    }
    
    // 处理 登录授权请求 回调
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == WXSuccess) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [self getAccessTokenWithSendAuthResp:authResp];
        }
        switch (resp.errCode) {
            case WXSuccess:
                //                [self showAlertWithmessage:@"微信授权成功"];
                break;
            case WXErrCodeAuthDeny:
                [self showAlertWithmessage:@"授权已拒绝"];
                break;
            case WXErrCodeUserCancel:
                [self showAlertWithmessage:@"已取消授权"];
                break;
            default:
                [self showAlertWithmessage:@"微信授权失败"];
                break;
        }
    }
}

- (void)showAlertWithmessage:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark  ************ 通过code 获取access_token **************

- (void)getAccessTokenWithSendAuthResp:(SendAuthResp *)authResp{
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeiXinAppKey,kWeiXinAppSecret,authResp.code];
    [[NetWork network] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 接口调用凭证
        NSString *access_token  = responseObject[@"access_token"];
        
        // access_token接口调用凭证超时时间，单位（秒）
        //        NSInteger expires_in    = [responseObject[@"expires_in"] integerValue];
        
        // access_token超时后可以用refresh_token 刷新 access_token (30天)
        //        NSString *refresh_token = responseObject[@"refresh_token"];
        
        // 用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
        //        NSString *unionid       = responseObject[@"unionid"];
        
        // 普通用户的标识，对当前开发者帐号唯一
        NSString *openid        = responseObject[@"openid"];
        
        // 用户授权的作用域，使用逗号（,）分隔   (比如用户的权限勾选部分)
        //        NSString *scope         = responseObject[@"scope"];
        
        

        
        
        
        
        
        [self getUserInfoWithAccess_token:access_token openid:openid];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get access_token failure");
    }];
}

#pragma mark   ************** get user info  **************
/*
 * 此接口用于获取用户个人信息。开发者可通过OpenID来获取用户基本信息。特别需要注意的是，如果开发者拥有多个
 * 移动应用、网站应用和公众帐号，可通过获取用户基本信息中的unionid来区分用户的唯一性，因为只要是同一个微
 * 信开放平台帐号下的移动应用、网站应用和公众帐号，用户的unionid是唯一的。换句话说，同一用户，对同一个微
 * 信开放平台下的不同应用，unionid是相同的。请注意，在用户修改微信头像后，旧的微信头像URL将会失效，因此
 * 开发者应该自己在获取用户信息后，将头像图片保存下来，避免微信头像URL失效后的异常情况。
 *
 */

- (void)getUserInfoWithAccess_token:(NSString *)access_token
                             openid:(NSString *)openid{
    NSString *infoUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
    [[NetWork network] GET:infoUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        WeXinUserInfo *userinfo = [[WeXinUserInfo alloc] init];
        [userinfo setValuesForKeysWithDictionary:responseObject];
        NSLog(@"\nuser info = %@",userinfo);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WECHAT_LOGIN" object:nil userInfo:@{KEYFORUSER:userinfo}];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get user info failure");
    }];
}

// 以下刷新access_token 暂时不考虑

#pragma mark  通过access_token接口获取到的refresh_token进行以下接口调用

- (void)getRefreshTokenWithRefreshToken:(NSString *)refresh_token{
    NSString *URLString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWeiXinAppKey,refresh_token];
    [[NetWork network] GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *access_token  = responseObject[@"access_token"];
        //        NSInteger expires_in    = [responseObject[@"expires_in"] integerValue];
        //        NSString *refresh_token = responseObject[@"refresh_token"];
        //        NSString *openid        = responseObject[@"openid"];
        //        NSString *scope         = responseObject[@"scope"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get open id failure");
    }];
}


#pragma mark   check access_token is ok   检验授权凭证（access_token）是否有效
- (void)checkAccessTokenIsOKWithAccess_token:(NSString *)access_token
                                      openid:(NSString *)openID
                                     success:(void(^)(BOOL isOk))success{
    NSString *UrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@",access_token,openID];
    [[NetWork network] GET:UrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(NO);
    }];
}




#pragma mark  -------------  微博部分 ------------------------


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"===== request =  %@",request);
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            NSString *wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            NSString *wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        
        NSString *wbtoken = [(WBAuthorizeResponse *)response accessToken];
        NSString *wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        NSString *wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        
        [self getWeiboUserInfoWithUid:wbCurrentUserID access_token:wbtoken];
        
//        NSString *URLS = @"https://api.weibo.com/oauth2/get_token_info";
//        NSDictionary *param = @{@"access_token":wbtoken};
//        [[NetWork network] POST:URLS parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSLog(@"剩余时间%@",responseObject);
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
        

        

        
       
//        [alert show];
    }
}

- (void)getWeiboUserInfoWithUid:(NSString *)uid access_token:(NSString *)access_token{
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json"];
    NSDictionary *param = @{@"access_token":access_token,@"uid":uid};
    [[NetWork network] GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@" %@ ",responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIBO_LOGIN" object:nil userInfo:@{KEYFORUSER:responseObject}];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
    
    
}



@end
