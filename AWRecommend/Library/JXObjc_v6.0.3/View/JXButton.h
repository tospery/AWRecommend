//
//  JXButton.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, JXAlignButtonMode){
//    JXAlignButtonModeLeft,
//    JXAlignButtonModeTop,
//    JXAlignButtonModeRight,
//    JXAlignButtonModeBottom
//};

typedef NS_ENUM(NSInteger, JXButtonStyle){
    JXButtonStyleNone,
    JXButtonStyleLeft,
    JXButtonStyleTop,
    JXButtonStyleRight,
    JXButtonStyleBottom,
    JXButtonStyleCustom1
};

@interface JXButton : UIButton
@property (nonatomic, strong) id obj;
@property (nonatomic, assign) JXButtonStyle style;
@property (nonatomic, assign) CGFloat distance;

@end
