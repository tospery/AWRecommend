//
//  JXTableViewCell.h
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXTableViewCell : UITableViewCell
//@property (nonatomic, strong) /*IBInspectable*/ UIImageView *splitter;
//@property (nonatomic, assign) IBInspectable UIEdgeInsets splitterInsets;

@property (nonatomic, strong) id data;

+ (NSString *)identifier;
+ (CGFloat)height;
+ (CGFloat)heightWithData:(id)data;
@end
