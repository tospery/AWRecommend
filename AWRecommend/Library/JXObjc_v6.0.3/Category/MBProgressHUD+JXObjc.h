//
//  MBProgressHUD+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//


#ifdef JXEnableLibMBProgressHUD
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, MBProgressHUDType){
    MBProgressHUDTypeNone,
    MBProgressHUDTypeSuccess,
    MBProgressHUDTypeFailure,
    MBProgressHUDTypeTips,
    MBProgressHUDTypeAll
};

@interface MBProgressHUD (JXObjc)
+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view
                         animated:(BOOL)animated
                     hideAnimated:(BOOL)hideAnimated
                        hideDelay:(NSTimeInterval)hideDelay
                             mode:(MBProgressHUDMode)mode
                             type:(MBProgressHUDType)type
                       customView:(UIView *)customView
                        labelText:(NSString *)labelText
                 detailsLabelText:(NSString *)detailsLabelText
                           square:(BOOL)square
                    dimBackground:(BOOL)dimBackground
                            color:(UIColor *)color
        removeFromSuperViewOnHide:(BOOL)removeFromSuperViewOnHide
                        labelFont:(CGFloat)labelFont
                 detailsLabelFont:(CGFloat)detailsLabelFont;

+ (MB_INSTANCETYPE)exShowHUDProcessingWithMessage:(NSString *)message
                                           detail:(NSString *)detail
                              whileExecutingBlock:(dispatch_block_t)block
                                  completionBlock:(MBProgressHUDCompletionBlock)completion;
@end
#endif
