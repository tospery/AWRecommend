//
//  JXCollapsibleView.h
//  MeijiaStore
//
//  Created by 杨建祥 on 16/1/12.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXCollapsibleViewMode){
    JXCollapsibleViewModeAuto,
    JXCollapsibleViewModeBase,
    JXCollapsibleViewModeClose,
    JXCollapsibleViewModeOpen
};

@interface JXCollapsibleView : UIView
@property (nonatomic, strong) NSString  *text;

- (void)setText:(NSString *)text font:(UIFont *)font lines:(NSInteger)lines;
- (void)setText:(NSString *)text font:(UIFont *)font lines:(NSInteger)lines textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor arrowColor:(UIColor *)arrowColor;

- (void)setBlockForPressed:(void (^)(JXCollapsibleViewMode mode))pressedBlock;
@end
