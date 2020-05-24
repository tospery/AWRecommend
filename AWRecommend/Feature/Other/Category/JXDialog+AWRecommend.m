//
//  JXDialog+AWRecommend.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXDialog+AWRecommend.h"
#import "ExpireViewController.h"
#import "PopupView.h"

@implementation JXDialog (AWRecommend)
+ (void)load{
    JXExchangeMethod(@selector(showPopup:), @selector(my_showPopup:));
}

- (void)my_showPopup:(NSString *)message {
    JXHUDHide();
    
    if (0 == message.length) {
        return;
    }
    
    [KLCPopup dismissAllPopups];
    
    PopupView *popupView = [[[NSBundle mainBundle] loadNibNamed:@"PopupView" owner:nil options:nil] firstObject];
    KLCPopup *popupModel = [KLCPopup popupWithContentView:popupView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    CGFloat duration = MAX((CGFloat)message.length * 0.06 + 0.5, 2.0);
    duration = MIN(duration, 8.0f);
    
    popupView.message = message;
    [popupModel showWithLayout:KLCPopupLayoutCenter duration:duration];
}

//- (void)my_error:(NSError *)error handler:(JXVoidBlock_id)handler {
//    if (!error) {
//        return;
//    }
//    
//    if (JXErrorCodeLoginExpired == error.code) {
//        UIViewController *currentVC = JXCurrentViewController();
//        
//        ExpireViewController *vc = [[ExpireViewController alloc] init];
//        vc.message = error.localizedDescription;
//        vc.okBlock = ^{
//            [currentVC jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut];
//        };
//        
//        [currentVC jx_presentPopupViewController:vc animationType:JXPopupShowTypeBounceIn layout:JXPopupLayoutCenter bgTouch:NO dismissed:NULL];
//        return;
//    }
//    
//    JXHUDError(error.localizedDescription, YES);
//}

@end
