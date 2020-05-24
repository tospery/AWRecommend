//
//  JXActionBar.h
//  JXSamples
//
//  Created by 杨建祥 on 16/6/1.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXActionCategory.h"
#import "JXActionSelection.h"
//#import "JXFilterViewSelectionContentTable.h"

@class JXActionBar;

@protocol JXActionBarDataSource <NSObject>
@required
- (UIView *)rootviewForActionBar:(JXActionBar *)actionBar;
- (CGFloat)topOffsetForActionBar:(JXActionBar *)actionBar;
- (NSInteger)numberOfCategoriesInActionBar:(JXActionBar *)actionBar;
- (JXActionCategory *)actionBar:(JXActionBar *)actionBar categoryAtIndex:(NSInteger)index;
- (JXActionSelection *)actionBar:(JXActionBar *)actionBar selectionAtIndex:(NSInteger)index;
@end

@protocol JXActionBarDelegate <NSObject>
@required
- (void)actionBar:(JXActionBar *)actionBar category:(JXActionCategory *)category selection:(JXActionSelection *)selection index:(NSInteger)index object:(id)object;
@optional
- (void)actionBar:(JXActionBar *)actionBar willShowContentView:(JXActionSelectionContent *)contentView;
- (void)actionBar:(JXActionBar *)actionBar willHideContentView:(JXActionSelectionContent *)contentView;

@end

@interface JXActionBar : UIView <JXActionCategoryDelegate, JXActionSelectionDelegate>
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, assign) CGFloat topOffset;
@property (nonatomic, weak) IBOutlet id<JXActionBarDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<JXActionBarDelegate> delegate;

- (void)reloadData;
@end


