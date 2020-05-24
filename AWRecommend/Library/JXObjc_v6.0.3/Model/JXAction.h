//
//  JXAction.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JXActionIndex){
    JXActionIndexDestructive,
    JXActionIndexCancel,
    JXActionIndexOther
};

typedef void(^JXActionClickBlock)(NSInteger index);

@interface JXAction : NSObject <UIAlertViewDelegate, UIActionSheetDelegate>
- (void)displayInController:(UIViewController *)controller
                 clickBlock:(JXActionClickBlock)clickBlock;

+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelActionTitle:(NSString *)cancelActionTitle
             otherActionTitles:(NSArray *)otherActionTitles;

+ (instancetype)sheetWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelActionTitle:(NSString *)cancelActionTitle
        destructiveActionTitle:(NSString *)destructiveActionTitle
             otherActionTitles:(NSArray *)otherActionTitles;

+ (instancetype)sheetWithAssetSheetMode:(JXAssetSheetMode)assetSheetMode;
@end