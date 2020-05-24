//
//  JXClassifyView.h
//  JXSamples
//
//  Created by 杨建祥 on 17/2/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXClassifyView;

@protocol JXClassifyViewDataSource <NSObject>
@required
//- (NSString *)classifyView:(JXClassifyView *)classifyView titleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)totalClassifiesWithClassifyView:(JXClassifyView *)classifyView;
- (void)classifyView:(JXClassifyView *)classifyView didCreateCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)classifyView:(JXClassifyView *)classifyView viewForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
//- (UIColor *)backgroundColorForSelectedWithClassifyView:(JXClassifyView *)classifyView;
//- (UIColor *)titleColorForSelectedWithClassifyView:(JXClassifyView *)classifyView;
- (void)classifyView:(JXClassifyView *)classifyView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JXClassifyView : UIView
@property (nonatomic, assign) IBInspectable CGFloat widthPercent;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, weak) IBOutlet id<JXClassifyViewDataSource> dataSource;
@property (nonatomic, strong) UITableView *tableView;

- (void)reloadData;

@end
