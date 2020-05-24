//
//  JXDialog.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JXDialog : NSObject
- (void)showHUD:(NSString *)title;
- (void)showPopup:(NSString *)message;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(JXVoidBlock_int)handler;
- (void)hideHUD;

+ (void)showHUD:(NSString *)title;
+ (void)showPopup:(NSString *)message;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(JXVoidBlock_int)handler;
+ (void)hideHUD;





//- (void)error:(NSError *)error handler:(JXVoidBlock_id)handler;
//+ (void)showError:(NSError *)error handler:(JXVoidBlock_id)handler;
//
//- (void)info:(NSString *)info;
//+ (void)showInfo:(NSString *)info;

@end
