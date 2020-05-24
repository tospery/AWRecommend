//
//  CompHeaderView.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompHeaderView : UIView
@property (nonatomic, weak) IBOutlet TTTAttributedLabel *quoteDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *quoteAuthLabel;
@property (nonatomic, weak) IBOutlet UIImageView *quoteImageView;
@property (nonatomic, weak) IBOutlet UIImageView *quoteImageView2;
@property (nonatomic, copy) JXVoidBlock didSearchBlock;
@property (nonatomic, copy) JXVoidBlock didScanBlock;

@end
