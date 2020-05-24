//
//  FavoriteCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/11.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteCell : SWTableViewCell
@property (nonatomic, strong) id data;

+ (NSString *)identifier;
+ (CGFloat)height;

@end