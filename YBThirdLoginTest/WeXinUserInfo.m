//
//  WeXinUserInfo.m
//  YBThirdLoginTest
//
//  Created by 一波 on 2017/4/25.
//  Copyright © 2017年 一波. All rights reserved.
//

#import "WeXinUserInfo.h"

@implementation WeXinUserInfo
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"\n****** error  undefinedKey : %@  *******",key);
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@" \n{\n    ++++ nickname : %@ sex :%ld headimgUrl: %@ unionid:%@ openid:%@\n}", _nickname,_sex,_headimgurl,_unionid,_openid];
}

@end
