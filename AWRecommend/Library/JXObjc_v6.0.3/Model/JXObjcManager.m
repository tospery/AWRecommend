//
//  JXObjcManager.m
//  MyCoding
//
//  Created by 杨建祥 on 16/5/7.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXObjcManager.h"

@implementation JXObjcManager
- (instancetype)init {
    if (self = [super init]) {
        self.pageStyle = JXObjcPageStyleGroup;
        
        //_envType = [[NSUserDefaults standardUserDefaults] integerForKey:kJXUdEnvType];
    }
    return self;
}

//- (JXEnvType)envType {
//    if (!_envType) {
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        _envType = [ud integerForKey:kJXUdEnvType];
//    }
//    return _envType;
//}

//- (void)setEnvType:(JXEnvType)envType {
//    _envType = envType;
//    [[NSUserDefaults standardUserDefaults] setInteger:envType forKey:kJXUdEnvType];
//}

- (void)setPageStyle:(JXObjcPageStyle)pageStyle {
    _pageStyle = pageStyle;
    if (JXObjcPageStyleGroup == pageStyle) {
        _pageIndex = 1;
    }else if (JXObjcPageStyleOffset == pageStyle) {
        _pageIndex = 99999999;
    }
    _pageSize = 20;
}

- (NSString *)systemFontName {
    if (0 == _systemFontName.length) {
        _systemFontName = [UIFont systemFontOfSize:12].fontName;
    }
    return _systemFontName;
}

- (CGFloat)fontFactor {
    if (0 == _fontFactor) {
        
#ifdef JXEnableAppAWKSZhixuan
        {
        _fontFactor = 1.0;
        JXDeviceInch inch = [JXDevice sharedInstance].inch;
        switch (inch) {
            case JXDeviceInch35:
                break;
            case JXDeviceInch40:
                break;
            case JXDeviceInch47:
                _fontFactor = 375 / 320.0;
                break;
            case JXDeviceInch55:
                _fontFactor = 414 / 320.0;
                break;
            default:
                break;
        }
        }

#else
            {
                if (JXDeviceIsPortrait) {
                    _fontFactor = [UIScreen mainScreen].bounds.size.width / 320.0f;
                }else {
                    _fontFactor = [UIScreen mainScreen].bounds.size.height / 320.0f;
                }
            }
#endif
    }
    return _fontFactor;
}

- (CGFloat)screenFactor {
    if (0 == _screenFactor) {
#ifdef JXEnableAppAWKSZhixuan
        {
        CGSize size = [UIScreen mainScreen].bounds.size;
        JXLogDebug(@"【JXObjc】屏幕分辨率：%@", NSStringFromCGSize(size));
        _screenFactor = size.width / 320.0f;
        }
#else
        {
        if (JXDeviceIsPortrait) {
            _screenFactor = [UIScreen mainScreen].bounds.size.width / 320.0f;
        }else {
            _screenFactor = [UIScreen mainScreen].bounds.size.height / 320.0f;
        }
        }
#endif
    }
    return _screenFactor;
}

//- (JXScanLib)scanLib {
//    if (0 == _scanLib) {
//        _scanLib = JXScanLibZXing;
//    }
//    return _scanLib;
//}

- (UIColor *)viewBgColor {
    if (!_viewBgColor) {
        _viewBgColor = [UIColor whiteColor];
    }
    return _viewBgColor;
}

- (UIColor *)mainColor {
    if (!_mainColor) {
        _mainColor = [UIColor blueColor];
    }
    return _mainColor;
}

- (UIColor *)navItemColor {
    if (!_navItemColor) {
        _navItemColor = [UIColor whiteColor];
    }
    return _navItemColor;
}
//
//- (UIFont *)cellTitleFont {
//    if (!_cellTitleFont) {
//        _cellTitleFont = JXFont(15.0f);
//    }
//    return _cellTitleFont;
//}
//
//- (UIColor *)cellTitleColor {
//    if (!_cellTitleColor) {
//        _cellTitleColor = JXColorHex(0x333333);
//    }
//    return _cellTitleColor;
//}
//
//- (UIFont *)cellDetailFont {
//    if (!_cellDetailFont) {
//        _cellDetailFont = JXFont(15.0f);
//    }
//    return _cellDetailFont;
//}
//
//- (UIColor *)cellDetailColor {
//    if (!_cellDetailColor) {
//        _cellDetailColor = JXColorHex(0x888888);
//    }
//    return _cellDetailColor;
//}

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
@end
