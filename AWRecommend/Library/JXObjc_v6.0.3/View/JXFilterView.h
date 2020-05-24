////
////  JXFilterView.h
////  MeijiaStore
////
////  Created by 杨建祥 on 16/1/2.
////  Copyright © 2016年 iOS开发组. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import "JXFilterViewCategory.h"
//#import "JXFilterViewSelection.h"
//#import "JXFilterViewSelectionContentTable.h"
//
//@class JXFilterView;
//
//@protocol JXFilterViewDataSource <NSObject>
//@required
//- (UIView *)rootviewForFilterView:(JXFilterView *)filterView;
//- (CGFloat)topOffsetForFilterView:(JXFilterView *)filterView;
//- (NSInteger)numberOfCategoriesInFilterView:(JXFilterView *)filterView;
//- (JXFilterViewCategory *)filterView:(JXFilterView *)filterView categoryAtIndex:(NSInteger)index;
//- (JXFilterViewSelection *)filterView:(JXFilterView *)filterView selectionAtIndex:(NSInteger)index;
//@end
//
//@protocol JXFilterViewDelegate <NSObject>
//@required
//- (void)filterView:(JXFilterView *)filterView
//          category:(JXFilterViewCategory *)category
//         selection:(JXFilterViewSelection *)selection
//             index:(NSInteger)index
//            object:(id)object;
//@optional
//- (void)filterView:(JXFilterView *)filterView willShowContentView:(JXFilterViewSelectionContent *)contentView;
//- (void)filterView:(JXFilterView *)filterView willHideContentView:(JXFilterViewSelectionContent *)contentView;
//
//@end
//
//@interface JXFilterView : UIView <JXFilterViewCategoryDelegate, JXFilterViewSelectionDelegate>
//@property (nonatomic, strong) UIView *rootView;
//@property (nonatomic, assign) CGFloat topOffset;
//@property (nonatomic, weak) IBOutlet id<JXFilterViewDataSource> dataSource;
//@property (nonatomic, weak) IBOutlet id<JXFilterViewDelegate> delegate;
//
//- (void)reloadData;
//@end
//
//
//
