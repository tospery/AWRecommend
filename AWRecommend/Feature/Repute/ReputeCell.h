//
//  ReputeCell.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/10/30.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReputeCell : JXCell
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *tagButtons;
@property (nonatomic, weak) IBOutlet UILabel *starLabel;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end
