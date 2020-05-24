//
//  SVProgressHUD+JXObjc.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "SVProgressHUD+JXObjc.h"

@implementation SVProgressHUD (JXObjc)
+ (void)jx_configWithInteraction:(BOOL)interaction {
    if (interaction) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    }else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

@end
