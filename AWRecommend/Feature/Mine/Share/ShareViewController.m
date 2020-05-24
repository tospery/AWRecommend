//
//  ShareViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/11.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"推荐给朋友";
    self.contentView.backgroundColor = JXColorHex(0xF7F8F9);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (IBAction)shareButtonPressed:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        [JXDialog showPopup:@"未安装微信，无法分享"];
        return;
    }
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        NSString *title = @"健康智选-药食同源专家";
        NSString *desc = @"桂圆？红枣？枸杞？远不止这些，更专业的搭配，色香味俱佳的组方茶饮，快来看看吧！";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:JXImageWithName(@"my_appicon")];
        shareObject.webpageUrl = @"http://dl.appvworks.com/doctor/user_app/index.html";
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            //            if (error) {
            //                JXHUDError(error.localizedDescription, YES);
            //            }
        }];
    }];
}

@end




