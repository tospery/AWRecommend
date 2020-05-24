//
//  NiceChannelView.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NiceChannelView : UIView
@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, copy) JXVoidBlock_string clickBlock;
@property (nonatomic, strong) NSArray *platforms;

@end
