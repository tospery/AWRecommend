//
//  JXCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/23.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXTableViewCell.h"

@interface JXCell : JXTableViewCell
@property (nonatomic, strong) UIImageView *separatorImageView;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, strong) UILabel *rightLabel;

@end
