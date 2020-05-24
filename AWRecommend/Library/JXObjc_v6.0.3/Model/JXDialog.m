//
//  JXDialog.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXDialog.h"

@interface JXDialog ()
@property (nonatomic, copy) JXVoidBlock_int alertHandler;
@property (nonatomic, copy) JXVoidBlock_id errorHandler;

@end

@implementation JXDialog
+ (void)showHUD:(NSString *)title {
    JXDialog *dialog = [[JXDialog alloc] init];
    [dialog showHUD:title];
}

+ (void)showPopup:(NSString *)message {
    JXDialog *dialog = [[JXDialog alloc] init];
    [dialog showPopup:message];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
    destructiveButtonTitle:(NSString *)destructiveButtonTitle
         otherButtonTitles:(NSArray *)otherButtonTitles
                   handler:(JXVoidBlock_int)handler {
    JXDialog *dialog = [[JXDialog alloc] init];
    [dialog showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles handler:handler];
}

+ (void)hideHUD {
    JXDialog *dialog = [[JXDialog alloc] init];
    [dialog hideHUD];
}

- (void)showHUD:(NSString *)title {
    JXHUDProcessing(title);
}

- (void)showPopup:(NSString *)message {
    if (0 == message.length) {
        return;
    }
    
    JXHUDInfo(message, YES);
}

- (void)showAlertWithTitle:(NSString *)title
               message:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
     otherButtonTitles:(NSArray *)otherButtonTitles
               handler:(JXVoidBlock_int)handler {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    if (0 != cancelButtonTitle.length) {
        [alertView addButtonWithTitle:cancelButtonTitle type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
            if (handler) {
                handler(JXAlertButtonStyleCancel);
            }
        }];
    }
    if (0 != destructiveButtonTitle.length) {
        [alertView addButtonWithTitle:destructiveButtonTitle type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
            if (handler) {
                handler(JXAlertButtonStyleDestructive);
            }
        }];
    }
    for (NSString *title in otherButtonTitles) {
        [alertView addButtonWithTitle:title type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
            if (handler) {
                handler(JXAlertButtonStyleDefault);
            }
        }];
    }
    [alertView show];
}

- (void)hideHUD {
    JXHUDHide();
}

//#pragma mark - error
//- (void)error:(NSError *)error handler:(JXVoidBlock_id)handler {
//    if (!error) {
//        return;
//    }
//    
//    JXHUDError(error.localizedDescription, YES);
//}
//
//+ (void)showError:(NSError *)error handler:(JXVoidBlock_id)handler {
//    JXDialog *dialog = [[JXDialog alloc] init];
//    [dialog error:error handler:handler];
//}
//
//
//#pragma mark - info
//- (void)info:(NSString *)info {
//    if (0 == info.length) {
//        return;
//    }
//    
//    JXHUDInfo(info, YES);
//}
//
//+ (void)showInfo:(NSString *)info {
//    JXDialog *dialog = [[JXDialog alloc] init];
//    [dialog info:info];
//}

@end
