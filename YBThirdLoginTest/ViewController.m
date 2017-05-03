//
//  ViewController.m
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/24.
//  Copyright © 2017年 一波. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate+ThirdPartLogin.h"
#import <UIImageView+WebCache.h>
#import "WeXinUserInfo.h"
#import "WeiBoUserInfo.h"
#import "NetWork.h"

@interface ViewController ()<TencentLoginDelegate,TencentSessionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *QQheaderImgView;
@property (weak, nonatomic) IBOutlet UIImageView *weiChartHeaderImgView;
@property (weak, nonatomic) IBOutlet UIImageView *weiBoHeadeImgView;
@property (weak, nonatomic) IBOutlet UILabel *QQNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *WeXinNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *WeiboNickNameLabel;

@property (nonatomic) TencentOAuth *tencentOAuth;



@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setWeChatData:) name:@"WECHAT_LOGIN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setWeiboData:) name:@"WEIBO_LOGIN" object:nil];
    
}


#pragma mark =======  QQ ==================

- (TencentOAuth *)tencentOAuth{
    if (!_tencentOAuth) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppID andDelegate:self];
    }
    return _tencentOAuth;
}

- (IBAction)QQloginAction:(id)sender {
        NSArray* permissions = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                nil];
        [self.tencentOAuth setAuthShareType:AuthShareType_QQ];
        [self.tencentOAuth authorize:permissions inSafari:NO];
    
    
}
//登录成功：
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken.length > 0) {
        // 获取用户信息 调用getUserInfoResponse:(APIResponse*) response 方法
//        [_tencentOAuth getUserInfo];
        NSLog(@"登录成功\n  openID :%@  token:%@ ",_tencentOAuth.openId,_tencentOAuth.accessToken);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录成功"
                                                        message:nil
                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        
        NSString *urlStr = [NSString stringWithFormat:@"https://graph.qq.com/user/get_user_info?access_token=%@&oauth_consumer_key=%@&openid=%@&format=json",_tencentOAuth.accessToken,kQQAppID,_tencentOAuth.openId];
        
        [[NetWork network] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            NSString *urlstr = responseObject[@"figureurl_qq_2"];
            if ([urlStr isKindOfClass:[NSString class]] && urlStr.length != 0) {
                [self.QQheaderImgView sd_setImageWithURL:[NSURL URLWithString:urlstr]];
            }else{
                NSString *urlstr = responseObject[@"figureurl_qq_1"];
                [self.QQheaderImgView sd_setImageWithURL:[NSURL URLWithString:urlstr]];
            }
            NSString *qqNickName = responseObject[@"nickname"];
            self.QQNickNameLabel.text = qqNickName;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
//        [alert show];
        
        
    } else {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

//非网络错误导致登录失败：
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        NSLog(@"用户取消登录");
    } else {
        NSLog(@"登录失败");
    }
}

- (void)tencentDidNotNetWork{
    NSLog(@"无网络连接，请设置网络");
}

- (void)getUserInfoResponse:(APIResponse*) response {
    NSString *urlstr = response.jsonResponse[@"figureurl_qq_2"];
    NSString *qqNickName = response.jsonResponse[@"nickname"];
    self.QQNickNameLabel.text = qqNickName;

    [self.QQheaderImgView sd_setImageWithURL:[NSURL URLWithString:urlstr]];
}


#pragma mark =======  weiXin ==================

- (IBAction)WeiChartLoginAction:(id)sender {
    
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo";
        req.openID = kWeiXinAppKey;
        req.state = @"1245";
        [WXApi sendReq:req];
    }else{
        //把微信登录的按钮隐藏掉。
    }
}

- (void)setWeChatData:(NSNotification *)noti{
    
    WeXinUserInfo *userInfo = noti.userInfo[KEYFORUSER];
    
    self.WeXinNickNameLabel.text = userInfo.nickname;
    [self.weiChartHeaderImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.headimgurl]];
    
}


#pragma mark =======  weibo ==================

- (IBAction)WeiboLoginAction:(id)sender {
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWeiBoRedirectURI;
    request.scope = @"all";
//    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)setWeiboData:(NSNotification *)noti{
    
    NSDictionary *data = noti.userInfo[KEYFORUSER];
    
    WeiBoUserInfo *wbUser = [[WeiBoUserInfo alloc] init];
    [wbUser setValuesForKeysWithDictionary:data];
    self.WeiboNickNameLabel.text = wbUser.name;
    [self.weiBoHeadeImgView sd_setImageWithURL:[NSURL URLWithString:wbUser.avatar_hd]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
