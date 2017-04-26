//
//  WeiBoUserInfo.m
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/26.
//  Copyright © 2017年 一波. All rights reserved.
//

#import "WeiBoUserInfo.h"

@implementation WeiBoUserInfo
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _wbUserID = (NSInteger)value;
    }
    if ([key isEqualToString:@"description"]) {
        _Userdescription = value;
    }
}
@end
