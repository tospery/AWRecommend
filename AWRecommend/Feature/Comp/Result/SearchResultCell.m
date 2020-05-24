//
//  SearchResultCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/16.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "SearchResultCell.h"

@interface SearchResultCell ()
@property (nonatomic, weak) IBOutlet UILabel *classifyLabel;
@property (nonatomic, weak) IBOutlet UIView *resultView;

@end

@implementation SearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CompResultList *)list {
    [super setData:list];
    
    self.classifyLabel.text = JXStrWithFmt(@"%@药品推荐", list.groupValue);
    
    [self.resultView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = list.datas.count;
//    if (0 == count) {
//        
//    }else if (1 == count) {
//
//    }else if (2 == count) {
//
//    }else if (3 == count) {
//
//    }else {
//
//    }
    CGFloat height = JXScreenScale(44);
    for (NSInteger i = 0; i < count; ++i) {
        if (3 == i) {
            UIView *view = [[UIView alloc] init];
            [self.resultView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.resultView);
                make.top.equalTo(self.resultView).offset(height * i);
                make.trailing.equalTo(self.resultView);
                make.height.equalTo(@(JXScreenScale(40)));
            }];
            
//            UIImageView *arrow = [[UIImageView alloc] initWithImage:JXImageWithName(@"ic_arrow_right")];
//            [view addSubview:arrow];
//            [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(view);
//                make.trailing.equalTo(view).offset(-12);
//                make.width.equalTo(@20);
//                make.height.equalTo(arrow.mas_width);
//            }];
            
            UIButton *arrow = [UIButton buttonWithType:UIButtonTypeCustom];
            [arrow addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [arrow setImage:JXImageWithName(@"ic_arrow_right") forState:UIControlStateNormal];
            [view addSubview:arrow];
            [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.trailing.equalTo(view).offset(-12);
                make.width.equalTo(@20);
                make.height.equalTo(arrow.mas_width);
            }];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            btn.titleLabel.font = JXFont(12);
            [btn setTitleColor:JXColorHex(0x999999) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            NSString *text = JXStrWithFmt(@"更多%ld种药品", (long)list.totalSize);
            [btn setTitle:text forState:UIControlStateNormal];
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.leading.equalTo(view).offset(20);
                make.centerY.equalTo(view);
                make.trailing.equalTo(arrow.mas_leading).offset(4);
            }];
            
            break;
        }
        UIView *view = [[UIView alloc] init];
        [self.resultView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.resultView);
            make.top.equalTo(self.resultView).offset(height * i);
            make.trailing.equalTo(self.resultView);
            make.height.equalTo(@(height));
        }];
        
        UIImageView *separator = [[UIImageView alloc] init];
        separator.backgroundColor = JXColorHex(0xe7e7e7);
        [view addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(view).offset(20);
            make.trailing.equalTo(view);
            make.bottom.equalTo(view);
            make.height.equalTo(@1);
        }];
        
//        UIImageView *arrow = [[UIImageView alloc] initWithImage:JXImageWithName(@"ic_arrow_right")];
//        [view addSubview:arrow];
//        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(view);
//            make.trailing.equalTo(view).offset(-12);
//            make.width.equalTo(@20);
//            make.height.equalTo(arrow.mas_width);
//        }];
        
        CompResultItem *item = list.datas[i];
        
        UIButton *arrow = [UIButton buttonWithType:UIButtonTypeCustom];
        arrow.tag = item.dId;
        [arrow addTarget:self action:@selector(itemButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [arrow setImage:JXImageWithName(@"ic_arrow_right") forState:UIControlStateNormal];
        [view addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.trailing.equalTo(view).offset(-12);
            make.width.equalTo(@20);
            make.height.equalTo(arrow.mas_width);
        }];
        
//        TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
//        label.numberOfLines = 2;
//        label.font = JXFont(13);
//        label.textColor = JXColorHex(0x333333);
//        label.lineSpacing = 2;
//        
//        CompResultItem *item = list.datas[i];
//        NSString *name = JXStrWithDft(item.dName, @"");
//        NSString *zz = JXStrWithDft(item.dcName, @"");
//        NSString *type = JXStrWithDft(item.dNatureType, @"");
//        NSString *text = JXStrWithFmt(@"%@  %@\n%@", name, type, zz);
//        [label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//            NSInteger index = name.length + 2;
//            NSRange range = NSMakeRange(index, text.length - index);
//            
//            UIFont *font = JXFont(10);
//            CTFontRef ref = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
//            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:range];
//            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ref range:range];
//            CFRelease(ref);
//            
//            [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
//            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[JXColorHex(0x999999) CGColor] range:range];
//            
//            return mutableAttributedString;
//        }];
//        
//        [view addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(view).offset(20);
//            make.trailing.equalTo(arrow.mas_leading).offset(4);
//            make.centerY.equalTo(view);
//        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //btn.titleLabel.font = JXFont(13);
        //btn.titleLabel.textColor = JXColorHex(0x333333);
        btn.tag = item.dId;
        btn.titleLabel.numberOfLines = 2;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(itemButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        //[btn setTitleColor:JXColorHex(0x333333) forState:UIControlStateNormal];
        
        NSString *name = JXStrWithDft(item.dName, @"");
        NSString *zz = JXStrWithDft(item.dcName, @"");
        NSString *type = JXStrWithDft(item.dNatureType, @"");
        NSString *text = JXStrWithFmt(@"%@  %@\n%@", name, type, zz);
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        [ps setLineSpacing:2];
        [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, text.length)];
        
        [as jx_addAttributeWithColor:JXColorHex(0x333333) font:JXFont(13) range:NSMakeRange(0, text.length)];
        [as jx_addAttributeWithColor:JXColorHex(0x999999) font:JXFont(10) range:NSMakeRange(name.length + 2, text.length - name.length - 2)];
        [btn setAttributedTitle:as forState:UIControlStateNormal];
        
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(view).offset(20);
            //make.trailing.equalTo(arrow.mas_leading).offset(4);
            make.centerY.equalTo(view);
        }];
    }
}

- (void)itemButtonPressed:(UIButton *)btn {
    if (self.itemDidPressBlock) {
        self.itemDidPressBlock(btn.tag);
    }
}

- (void)moreButtonPressed:(id)sender {
    if (self.moreDidPressBlock) {
        CompResultList *list = self.data;
        self.moreDidPressBlock(list.groupValue);
    }
}

+ (CGFloat)heightWithData:(CompResultList *)list {
    CGFloat height = JXScreenScale(48);
    NSInteger count = list.datas.count;
    if (0 == count) {
        
    }else if (1 == count) {
        height += JXScreenScale(44);
    }else if (2 == count) {
        height += (JXScreenScale(44) * 2);
    }else if (3 == count) {
        height += (JXScreenScale(44) * 3);
    }else {
        height += ((JXScreenScale(44) * 3) + JXScreenScale(40));
    }
    return height;
}

@end
