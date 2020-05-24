//
//  JXActionCategory.h
//  JXSamples
//
//  Created by 杨建祥 on 16/6/2.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JXActionCategory;

@protocol JXActionCategoryDelegate <NSObject>
@required
- (void)actionCategory:(JXActionCategory *)category didSelectIndex:(NSInteger)index;

@end

@interface JXActionCategory : UIView
@property (nonatomic, assign) BOOL isSort;
@property (nonatomic, assign) BOOL sortPositive;

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic, weak) id<JXActionCategoryDelegate> delegate;

@end