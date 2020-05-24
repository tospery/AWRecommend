//
//  PopupView.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/7/28.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "PopupView.h"

@interface PopupView ()
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation PopupView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = SMInstance.mainColor;
    
    self.textView.font = JXFont(14);
    self.textView.textColor = [UIColor whiteColor];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    
    if (0 == message.length) {
        return;
    }
    
    CGFloat width = JXAdaptScreen(240.0f);
    CGFloat height = JXAdaptScreen(320.0f);
    
    CGFloat padding = 2 * 8.0 + 16.0;
    
    NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:message color:[UIColor whiteColor] font:self.textView.font];
    CGSize allSize = [mas jx_sizeWithWidth:(width - padding)];
    
    NSMutableAttributedString *oneChar = [NSMutableAttributedString jx_attributedStringWithString:@"我" color:[UIColor whiteColor] font:self.textView.font];
    CGSize oneSize = [oneChar jx_sizeWithWidth:(width - padding)];
    
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.alignment = (allSize.height > oneSize.height) ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    [mas removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, mas.length)];
    [mas addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, mas.length)];
    
    self.textView.attributedText = mas;
    
    if (NSTextAlignmentCenter == ps.alignment) {
        width = allSize.width + padding;
    }
    
    CGFloat need = allSize.height + padding;
    height = (need > height ? height : need);
    self.frame = CGRectMake(0, 0, width, height);
    [self jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
    
    [self.textView scrollRangeToVisible:NSMakeRange(0, 1)];
}

//- (void)configUI {
//    if (0 == self.message.length) {
//        return;
//    }
//    
////    CGFloat width = JXAdaptScreen(240.0f);
////    CGFloat height = JXAdaptScreen(320.0f);
////    
////    NSMutableAttributedString *mas = [NSMutableAttributedString jx_attributedStringWithString:self.message color:[UIColor whiteColor] font:JXFont(14.0f)];
////    CGSize size = [mas jx_sizeWithWidth:(width - 2 * 8.0 - 16.0)];
////    
////    NSMutableAttributedString *oneChar = [NSMutableAttributedString jx_attributedStringWithString:@"我" color:[UIColor whiteColor] font:JXFont(14.0f)];
////    CGSize oneSize = [oneChar jx_sizeWithWidth:(width - 2 * 8.0 - 16.0)];
////    
////    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
////    paragraphStyle.alignment = (size.height > oneSize.height) ? NSTextAlignmentLeft : NSTextAlignmentCenter;
////    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
////    [mas removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, mas.length)];
////    [mas addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mas.length)];
////    
////    CGFloat need = size.height + 16.0 + 8.0 + 16.0;
////    if (0 != self.title.length) {
////        NSMutableAttributedString *subMas = [NSMutableAttributedString jx_attributedStringWithString:self.title color:[UIColor whiteColor] font:JXFont(16.0f)];
////        CGSize subSize = [subMas jx_sizeWithWidth:CGFLOAT_MAX];
////        need += (subSize.height);
////    } else {
////        self.topConstraint.constant = -8.0f;
////        need -= 8.0f;
////    }
////    
////    height = (need > height ? height : need);
////    
////    self.titleLabel.text = self.title;
////    self.messageTextView.attributedText = mas;
////    
////    self.frame = CGRectMake(0, 0, width, height);
////    [self jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
////    
////    // [self.messageTextView scrollsToTop];
////    [self.messageTextView scrollRangeToVisible:NSMakeRange(0, 1)];
//    
//    //[self.view layoutIfNeeded];
//}

@end
