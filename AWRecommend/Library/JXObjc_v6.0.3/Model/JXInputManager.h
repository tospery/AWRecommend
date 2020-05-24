//
//  JXInputManager.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXInputManagerLimit){
    JXInputManagerLimitCompatible,      // 不区分
    JXInputManagerLimitDistinguish    // 1个汉字占2个字符
};

typedef NS_ENUM(NSInteger, JXInputManagerVerify){
    JXInputManagerVerifyNone,
    JXInputManagerVerifyNeed,                   // 不能为空
    JXInputManagerVerifyWhitespaceLT,           // 首尾不能包含空白字符
    JXInputManagerVerifyWhitespaceAll,          // 输入不能全为空白字符
    JXInputManagerVerifyPureChars,              // 纯英文
    JXInputManagerVerifyPureNums,               // 纯数字
    JXInputManagerVerifyPureASCII,              // 纯英文+数字
    JXInputManagerVerifyLeast,                  // 至少输入
    JXInputManagerVerifySame                    // 不能相同
};

@interface UITextField (JXInputManagerCategory)
- (void)exSetupLimit:(NSUInteger)limit;
@end

@interface UITextView (JXInputManagerCategory)
- (void)exSetupLimit:(NSUInteger)limit;
@end

@interface JXInputManager : NSObject
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) JXInputManagerLimit type;

- (void)setupExceedBlock:(void(^)(UIView *inputView, NSUInteger exceed))exceedBlock countBlock:(void(^)(UIView *inputView, NSUInteger count))countBlock;


/**
 *  单例
 *
 *  @return 单例
 */
+ (JXInputManager *) sharedInstance;

/**
 *  验证手机号
 *
 *  @param phone 手机号
 *  @param original    原手机号
 *
 *  @return 验证失败描述，nil表示成功
 */
+ (NSString *)verifyPhone:(NSString *)phone
                 original:(NSString *)original;

+ (NSString *)verifyEmail:(NSString *)email original:(NSString *)original;

/**
 *  验证至少输入
 *
 *  @param input 输入
 *  @param least 至少
 *  @param title 标题
 *
 *  @return 验证结果，nil表示成功
 */
+ (NSString *)verifyInput:(NSString *)input
                    least:(NSInteger)least
                 original:(NSString *)original
                    title:(NSString *)title;

+ (NSString *)verifyInput:(NSString *)input
                    least:(NSInteger)least
                 original:(NSString *)original
               mustPrefix:(NSString *)mustPrefix
               mustSuffix:(NSString *)mustSuffix
              mustSymbols:(NSString *)mustSymbols
               cantPrefix:(NSString *)cantPrefix
               cantSuffix:(NSString *)cantSuffix
              cantSymbols:(NSString *)cantSymbols
                    title:(NSString *)title
                  message:(NSString *)message;

// 备份


/**
 *  验证输入（不支持本地化）
 *
 *  @param input          输入
 *  @param least          至少
 *  @param original       原来
 *  @param ltSpaces       是否允许首尾空白
 *  @param containLetters 是否包含字母
 *  @param containNumbers 是否包含数字
 *  @param containSymbols 是否包含符号
 *  @param title          标题
 *
 *  @return 提示信息
 */
//+ (NSString *)verifyInput:(NSString *)input
//                    least:(NSInteger)least
//                 original:(NSString *)original
//                 ltSpaces:(BOOL)ltSpaces
//                  symbols:(NSString *)symbols
//                    title:(NSString *)title
//                  message:(NSString *)message;
//
////+ (NSString *)verifyInput:(NSString *)input
////                    least:(NSInteger)least
////                 original:(NSString *)original
////                 ltSpaces:(BOOL)ltSpaces
////           containLetters:(BOOL)containLetters
////           containNumbers:(BOOL)containNumbers
////                    title:(NSString *)title;
//
//+ (NSString *)verifyInput:(NSString *)input
//                    least:(NSInteger)least
//                 original:(NSString *)original
//            spacesAllowed:(BOOL)spacesAllowed
//                pureChars:(BOOL)pureChars
//                 pureNums:(BOOL)pureNums
//                     name:(NSString *)name;
//+ (JXInputManagerVerify)verifyInput:(NSString *)input
//                              least:(NSInteger)least
//                           original:(NSString *)original
//                      spacesAllowed:(BOOL)spacesAllowed
//                          pureChars:(BOOL)pureChars
//                           pureNums:(BOOL)pureNums;
@end
