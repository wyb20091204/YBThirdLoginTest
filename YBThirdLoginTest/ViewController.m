//
//  ViewController.m
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/24.
//  Copyright © 2017年 一波. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+WebCache.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *QQheaderImgView;

@property (weak, nonatomic) IBOutlet UIImageView *weiChartHeaderImgView;
@property (weak, nonatomic) IBOutlet UIImageView *weiBoHeadeImgView;
@property (weak, nonatomic) IBOutlet UILabel *QQNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *WeXinNickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *WeiboNickNameLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
}


- (IBAction)QQloginAction:(id)sender {
    
    [self.QQheaderImgView sd_setImageWithURL:[NSURL URLWithString:@"http://q.qlogo.cn/qqapp/1106118074/C95E6EC3CE0F908A2F97C57F0BB311C9/100"]];
    
    self.QQNickNameLabel.text = @"eeeeeee";

    
    
    
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
