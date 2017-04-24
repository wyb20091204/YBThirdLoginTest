//
//  ViewController.m
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/24.
//  Copyright © 2017年 一波. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+WebCache.h>
#import "AppDelegate+QQ.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
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
//
//    [self.QQheaderImgView sd_setImageWithURL:[NSURL URLWithString:@"http://q.qlogo.cn/qqapp/1106118074/C95E6EC3CE0F908A2F97C57F0BB311C9/100"]];
//    
//    self.QQNickNameLabel.text = @"eeeeeee";

    
    
    
}
//登录成功：
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken.length > 0) {
        // 获取用户信息
        [_tencentOAuth getUserInfo];
        NSLog(@"登录成功\n  openID :%@  token:%@ ",_tencentOAuth.openId,_tencentOAuth.accessToken);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录成功"
                                                        message:nil
                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
        
        
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


- (IBAction)WeiChartLoginAction:(id)sender {
}



- (IBAction)WeiboLoginAction:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
