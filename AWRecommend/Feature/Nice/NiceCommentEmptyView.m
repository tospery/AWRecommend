//
//  NiceCommentEmptyView.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceCommentEmptyView.h"

@interface NiceCommentEmptyView ()
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *messageLabel;
@end

@implementation NiceCommentEmptyView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageLabel.text = @"还没有评论\n快来抢沙发吧~";
}

@end
