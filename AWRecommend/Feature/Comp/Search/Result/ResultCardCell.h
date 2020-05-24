//
//  ResultCardCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/16.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultCardCell : JXTableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *splitImageView;
@property (nonatomic, copy) JXVoidBlock_int matchBlock;

@end
