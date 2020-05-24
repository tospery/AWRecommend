//
//  FavoriteArticleCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/26.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteArticleCell : SWTableViewCell
@property (nonatomic, strong) id data;

+ (NSString *)identifier;
+ (CGFloat)height;

@end
