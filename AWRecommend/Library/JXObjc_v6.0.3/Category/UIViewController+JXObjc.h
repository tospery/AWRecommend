//
//  UIViewController+JXObjc.h
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPage.h"

typedef JXVoidBlock JXLoginCheckPassBlock;
//typedef JXVoidBlock JXLoginReloginedBlock;
typedef JXVoidBlock JXLoginFinishBlock;
typedef JXVoidBlock JXLoginWillPresentBlock;
typedef JXVoidBlock JXLoginDidPresentBlock;
typedef JXVoidBlock JXLoginWillCancelBlock;
typedef JXVoidBlock JXLoginDidCancelBlock;
typedef JXVoidBlock JXLoginWillReloginBlock;
typedef JXVoidBlock JXLoginDidReloginBlock;

typedef JXVoidBlock JXWebResultCallback;

@interface UIViewController (JXObjc)
// - (BOOL)checkLoginWithError:(NSError *)error finish:(JXLoginDidPassBlock)finish;

//- (void)handleSuccessForTableView:(UITableView *)tableView
//                             mode:(JXWebMode)mode
//                             page:(JXPage *)page
//                            items:(NSMutableArray *)items
//                          results:(NSArray *)results
//                            image:(UIImage *)image
//                          message:(NSString *)message
//                        functitle:(NSString *)functitle
//                         callback:(JXWebResultCallback)callback;
//
//- (void)handleFailureWithView:(UIView *)view mode:(JXWebMode)mode way:(JXWebWay)way error:(NSError *)error callback:(JXWebResultCallback)callback;

#ifdef JXEnableFucCheckLogin
- (void)showLoginIfNotWithFinish:(JXLoginFinishBlock)finish;
- (BOOL)showAuthidWithFinish:(JXVoidBlock)finish cancel:(JXVoidBlock)cancel;
#endif
@end



