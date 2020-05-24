//
//  JXCellValue1.m
//  JXSamples
//
//  Created by 杨建祥 on 16/4/23.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXCellValue1.h"

@implementation JXCellValue1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
//        self.textLabel.font = JXInstance.cellTitleFont;
//        self.textLabel.textColor = JXInstance.cellTitleColor;
//        
//        self.detailTextLabel.font = JXInstance.cellDetailFont;
//        self.detailTextLabel.textColor = JXInstance.cellDetailColor;
        
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

@end


//@implementation JXCellValue1Manager
//- (UIFont *)titleFont {
//    if (JXDataIsEmpty(_titleFont)) {
//        _titleFont = JXFont(15.0f);
//    }
//    return _titleFont;
//}
//
//- (UIColor *)titleColor {
//    if (JXDataIsEmpty(_titleColor)) {
//        _titleColor = JXColorHex(0x333333);
//    }
//    return _titleColor;
//}
//
//- (UIFont *)detailFont {
//    if (JXDataIsEmpty(_detailFont)) {
//        _detailFont = JXFont(15.0f);
//    }
//    return _detailFont;
//}
//
//- (UIColor *)detailColor {
//    if (JXDataIsEmpty(_detailColor)) {
//        _detailColor = JXColorHex(0x888888);
//    }
//    return _detailColor;
//}
//
//+ (JXCellValue1Manager *)sharedInstance {
//    static JXCellValue1Manager *instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[JXCellValue1Manager alloc] init];
//    });
//    return instance;
//}
//@end
