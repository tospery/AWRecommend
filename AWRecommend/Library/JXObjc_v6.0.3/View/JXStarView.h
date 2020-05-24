//
//  JXStarView.h
//  MeijiaStore
//
//  Created by 杨建祥 on 16/1/2.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXObjc.h"

//typedef void(^JXStarViewDidSelectBlock)(NSInteger level);

typedef JXVoidBlock_int JXStarViewDidSelectBlock;

@interface JXStarView : UIView
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *unselectedImage;

- (void)setupDidSelectBlock:(JXStarViewDidSelectBlock)didSelectBlock;
- (void)loadData;
@end