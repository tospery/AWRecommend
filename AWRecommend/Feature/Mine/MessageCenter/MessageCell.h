//
//  MessageCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/8/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : SWTableViewCell
@property (nonatomic, strong) id data;

+ (NSString *)identifier;
+ (CGFloat)heightWithData:(Message *)m;
@end
