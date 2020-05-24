//
//  Util.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/4.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "Util.h"
#import "ScanViewController.h"
#import "ScanPopupViewController.h"
#import "ChatViewController.h"

@implementation Util
+ (NSString *)stringWithSearchClassify:(SearchClassifyType)classify {
    NSArray *strs = @[@"儿童症状", @"儿童药品", @"成人症状", @"成人药品"];
    if (classify <= SearchClassifyNone ||
        classify >= SearchClassifyTotal) {
        return nil;
    }
    
    return strs[classify - 1];
}

+ (BOOL)isMedicineWithSearchClassify:(SearchClassifyType)classify {
    if (classify == SearchClassifyChildrenMedicine ||
        classify == SearchClassifyAdultMedicine) {
        return YES;
    }
    return NO;
}

+ (NSString *)stringWithPeopleType:(PeopleType)type {
    NSArray *strs = @[@"儿童", @"成人"];
    if (type <= PeopleTypeNone ||
        type >= PeopleTypeTotal) {
        return nil;
    }
    
    return strs[type - 1];
}

+ (NSString *)stringWithNatureType:(NatureType)type {
    if (NatureTypeZhongyao == type) {
        return @"中成药";
    }else if (NatureTypeXiyao == type) {
        return @"西药";
    }else if (NatureTypeOther == type) {
        return @"其他";
    }
    
    return nil;
}

+ (NSString *)securityWithValue:(CGFloat)value {
    if (0.5 == value) {
        return @"药品有不良反应，且对重要脏器有影响";
    }else if (0.8 == value) {
        return @"药品有不良反应，但对重要脏器无影响";
    }else if (1 == value) {
        return @"药品无不良反应、或不良反应未发现、或不良反应尚不明确";
    }
    
    return @"暂无";
}

+ (NSString *)stabilityWithValue:(CGFloat)value {
    if (0.5 == value) {
        return @"药品常温储存年数小于1年";
    }else if (0.8 == value) {
        return @"药品常温储存年数为1~2年";
    } else if (1 == value) {
        return @"药品常温储存年数大于2年";
    }
    
    return @"暂无";
}

+ (NSString *)stringWithSearchKind:(SearchKind)kind {
    if (SearchKindSickness == kind) {
        return @"疾病症状";
    }else if (SearchKindMedicine == kind) {
        return @"药品名称";
    }else {
        return nil;
    }
}

+ (NSString *)titleWithSearchKind:(SearchKind)kind {
    if (SearchKindSickness == kind) {
        return @"症状";
    }else if (SearchKindMedicine == kind) {
        return @"药品";
    }else {
        return nil;
    }
}

@end

NSString * GenderTypeString(GenderType t) {
    NSString *ret = @"暂无";
    switch (t) {
        case GenderTypeMale:
            ret = @"男";
            break;
        case GenderTypeFemale:
            ret = @"女";
            break;
        default:
            break;
    }
    return ret;
}


NSString * MedicineTagString(MedicineTag num) {
    NSArray *strs = @[@"中药保护类一级",
                      @"专利药是指已获得专利保护的药品",
                      @"国家基本药物是指由政府制定的《国家基本药物目录》中的药品。甄选原则：临床必需、安全有效、价格合理、使用方便、中西药并重。"];
    if (num < 1 || num > strs.count) {
        return @"";
    }
    
    return strs[num - 1];
}

UIColor * MedicineTagColor(MedicineTag num) {
    NSArray *strs = @[JXColorHex(0xFF9F42), JXColorHex(0x67B0ED),JXColorHex(0x62cdbf)];
    if (num < 1 || num > strs.count) {
        return [UIColor blackColor];
    }
    
    return strs[num - 1];
}

NSString * ShortcutTypeString(ShortcutType type) {
    NSArray *strs = @[@"按症状查", @"按药名查"];
    if (type < 1 || type > strs.count) {
        return nil;
    }
    
    return strs[type - 1];
}


void EntryScan(UINavigationController *nav) {
    if (gUser.isLogined == NO && gMisc.skipScanPopup == NO) {
        ScanPopupViewController *vc = [[ScanPopupViewController alloc] init];
        
        //@weakify(self)
        vc.didCloseBlock = ^() {
            //@strongify(self)
            [nav jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut];
        };
        
        vc.didSkipBlock = ^{
            //@strongify(self)
            gMisc.skipScanPopup = YES;
            [nav jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut dismissed:^{
                //@strongify(self)
                ScanViewController *vc = [[ScanViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:vc animated:YES];
            }];
        };
        
        vc.didLoginBlock = ^{
            //@strongify(self)
            [nav jx_dismissPopupViewControllerWithAnimationType:JXPopupDismissTypeBounceOut dismissed:^{
//                //@strongify(self)
//                [gUser checkLoginWithFinish:^{
//                    //@strongify(self)
//                    ScanViewController *vc = [[ScanViewController alloc] init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [nav pushViewController:vc animated:YES];
//                } error:nil];
                
                [gUser checkLoginWithFinish:^(BOOL isRelogin) {
                    ScanViewController *vc = [[ScanViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [nav pushViewController:vc animated:YES];
                } error:nil];
            }];
        };
        
        [nav jx_presentPopupViewController:vc animationType:JXPopupShowTypeBounceIn layout:JXPopupLayoutCenter bgTouch:NO dismissed:^{
            
        }];
        return;
    }
    
    ScanViewController *vc = [[ScanViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:vc animated:YES];
}

RACCommand * EntryChat(JXViewController *viewController) {
    RACCommand *doctorCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [HRInstance doctorsCustomersList];
    }];
    [doctorCommand.executing subscribe:viewController.executing];
    //[doctorCommand.errors subscribe:viewController.errors];
    [[doctorCommand.errors filter:^BOOL(NSError *error) {
        if (JXErrorCodeDataEmpty == error.code) {
            [JXDialog showPopup:@"没有可用的医师"];
            return NO;
        }
        return YES;
    }] subscribe:viewController.errors];
    
    [doctorCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *doctors) {
        if (0 == doctors.count) {
            [JXDialog showPopup:@"没有可用的医师"];
        }else {
            Doctor *d = doctors[0];
            // d.doctorId = @"D190";
            if (0 == d.doctorId.length) {
                // JXHUDError(@"无效的医师", YES);
                [JXDialog showPopup:@"无效的医师"];
            }else {
                if (0 == d.doctorName.length) {
                    d.doctorName = d.doctorId;
                }
                
                [UIImage jx_imageWithRemoteURL:JXURLWithStr(d.avatar) localName:d.avatar dftImage:JXImageWithName(@"img_UserCenter_consultant") finish:^(UIImage *doctorImage) {
                    d.dImage = doctorImage;
                    
                    [UIImage jx_imageWithRemoteURL:JXURLWithStr(gUser.avatar) localName:gUser.avatar dftImage:JXImageWithName(@"img_UserCenter_default") finish:^(UIImage *userImage) {
                        d.aImage = userImage;
                        
                        TIMConversation *conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:d.doctorId/*@"D190"*/];
                        
                        NSMutableArray *msgs = [NSMutableArray array];
                        [conv getMessage:20 last:nil succ:^(NSArray * msgList) {
                            for (TIMMessage *message in msgList) {
                                int cnt = [message elemCount];
                                
                                for (int i = 0; i < cnt; i++) {
                                    TIMElem *elem = [message getElem:i];
                                    
                                    if ([elem isKindOfClass:[TIMTextElem class]]) {
                                        TIMTextElem *textElem = (TIMTextElem * )elem;
                                        
                                        NSString *sid = [message sender];
                                        NSString *sname = d.doctorName;
                                        if (![sid isEqualToString:d.doctorId]) {
                                            sid = JXStrWithFmt(@"A%@", gUser.jxID);
                                            sname = gUser.nickName;
                                            if (0 == sname.length) {
                                                sname = gUser.mobile;
                                            }
                                            if (0 == sname.length) {
                                                sname = @"我";
                                            }
                                        }
                                        NSDate *date = [message timestamp];
                                        JSQMessage *m = [[JSQMessage alloc] initWithSenderId:sid senderDisplayName:sname date:date text:textElem.text];
                                        [msgs insertObject:m atIndex:0];
                                    }
                                }
                            }
                            
                            ChatViewController *vc = [[ChatViewController alloc] init];
                            vc.doctor = d;
                            vc.msgs = msgs;
                            vc.hidesBottomBarWhenPushed = YES;
                            [viewController.navigationController pushViewController:vc animated:YES];
                            
                            [JXDialog hideHUD];
                            
                        }fail:^(int code, NSString * err) {
                            ChatViewController *vc = [[ChatViewController alloc] init];
                            vc.doctor = d;
                            vc.hidesBottomBarWhenPushed = YES;
                            [viewController.navigationController pushViewController:vc animated:YES];
                            
                            [JXDialog hideHUD];
                        }];
                    }];
                }];
            }
        }
    }];
    return doctorCommand;
}



