//
//  JXAction.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXAction.h"

typedef NS_ENUM(NSInteger, JXActionType){
    JXActionTypeAlert,
    JXActionTypeSheet
};

@interface JXAction ()
@property (nonatomic, assign) JXAssetSheetMode assetSheetMode;
@property (nonatomic, assign) JXActionType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *cancelActionTitle;
@property (nonatomic, strong) NSString *destructiveActionTitle;
@property (nonatomic, strong) NSArray *otherActionTitles;
@property (nonatomic, copy) JXActionClickBlock clickBlock;
@end

@implementation JXAction
+ (instancetype)sheetWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelActionTitle:(NSString *)cancelActionTitle
        destructiveActionTitle:(NSString *)destructiveActionTitle
             otherActionTitles:(NSArray *)otherActionTitles {
    JXAction *action = [[JXAction alloc] init];
    action.type = JXActionTypeSheet;
    action.title = title;
    action.message = message;
    action.cancelActionTitle = cancelActionTitle;
    action.destructiveActionTitle = destructiveActionTitle;
    action.otherActionTitles = otherActionTitles;
    return action;
}

+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelActionTitle:(NSString *)cancelActionTitle
             otherActionTitles:(NSArray *)otherActionTitles {
    JXAction *action = [[JXAction alloc] init];
    action.type = JXActionTypeAlert;
    action.title = title;
    action.message = message;
    action.cancelActionTitle = cancelActionTitle;
    action.otherActionTitles = otherActionTitles;
    return action;
}

+ (instancetype)sheetWithAssetSheetMode:(JXAssetSheetMode)assetSheetMode {
    JXAction *action;
    if (JXAssetSheetModeOnlyPhoto == assetSheetMode) {
        action = [JXAction sheetWithTitle:nil message:nil cancelActionTitle:kStringCancel destructiveActionTitle:nil otherActionTitles:@[kStringTakePhoto, kStringChooseFromAlbum]];
    }else if (JXAssetSheetModeMedia == assetSheetMode) {
        action = [JXAction sheetWithTitle:nil message:nil cancelActionTitle:kStringCancel destructiveActionTitle:nil otherActionTitles:@[kStringTakePhoto, kStringShoot, kStringChooseFromAlbum]];
    }
    action.assetSheetMode = assetSheetMode;
    return action;
}

- (void)displayInController:(UIViewController *)controller
                 clickBlock:(JXActionClickBlock)clickBlock {
    _clickBlock = clickBlock;
    
    if (JXActionTypeAlert == _type) {
        [self displayAlertInController:controller];
    }else if (JXActionTypeSheet == _type) {
        [self displaySheetInController:controller];
    }
}

- (void)displaySheetInController:(UIViewController *)controller {
    if (!JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:_title delegate:self cancelButtonTitle:_cancelActionTitle destructiveButtonTitle:_destructiveActionTitle otherButtonTitles: nil];
        for(id other in _otherActionTitles)  {
            [sheet addButtonWithTitle:[other description]];
        }
        [sheet showInView:controller.view];
        
        return;
    }
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleActionSheet];
    if (_cancelActionTitle.length != 0) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:_cancelActionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self callbackWithIndex:JXActionIndexCancel];
        }];
        [sheet addAction:cancelAction];
    }
    if (_destructiveActionTitle.length != 0) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:_destructiveActionTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self callbackWithIndex:JXActionIndexDestructive];
        }];
        [sheet addAction:destructiveAction];
    }
    for (NSInteger i = 0; i < _otherActionTitles.count; ++i) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:[_otherActionTitles[i] description] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self callbackWithIndex:(JXActionIndexOther + i)];
        }];
        [sheet addAction:otherAction];
    }
    [controller presentViewController:sheet animated:YES completion:NULL];
}

- (void)displayAlertInController:(UIViewController *)controller {
    if (!JXiOSVersionGreaterThanOrEqual(@"8.0")) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title message:_message delegate:self cancelButtonTitle:_cancelActionTitle otherButtonTitles:nil];
        for(NSString *other in _otherActionTitles)  {
            [alert addButtonWithTitle:other];
        }
        [alert show];
        
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleAlert];
    if (_cancelActionTitle.length != 0) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:_cancelActionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self callbackWithIndex:JXActionIndexCancel];
        }];
        [alert addAction:cancelAction];
    }
    for (NSInteger i = 0; i < _otherActionTitles.count; ++i) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:_otherActionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self callbackWithIndex:(JXActionIndexOther + i)];
        }];
        [alert addAction:otherAction];
    }
    [controller presentViewController:alert animated:YES completion:NULL];
}

- (void)callbackWithIndex:(NSInteger)index {
    NSInteger result = index;
    
    if (JXAssetSheetModeOnlyPhoto == _assetSheetMode) {
        if (1 == index) {
            result = JXAssetPickerModeNone;
        }else if (2 == index) {
            result = JXAssetPickerModeTakePhoto;
        }else if (3 == index) {
            result = JXAssetPickerModeAlbumPhoto;
        }else {
            result = JXAssetPickerModeNone;
        }
    }else if (JXAssetSheetModeOnlyVideo == _assetSheetMode) {
        
    }else if (JXAssetSheetModeMedia == _assetSheetMode) {
        if (1 == index) {
            result = JXAssetPickerModeNone;
        }else if (2 == index) {
            result = JXAssetPickerModeTakePhoto;
        }else if (3 == index) {
            result = JXAssetPickerModeTakeVideo;
        }else if (4 == index) {
            result = JXAssetPickerModeAlbumMedia;
        }else {
            result = JXAssetPickerModeNone;
        }
    }
    
    if (_clickBlock) {
        _clickBlock(result);
        _clickBlock = NULL;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self callbackWithIndex:(buttonIndex + 1)];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self callbackWithIndex:buttonIndex];
}
@end
