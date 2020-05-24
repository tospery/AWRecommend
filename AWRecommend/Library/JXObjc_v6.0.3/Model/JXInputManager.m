//
//  JXInputManager.m
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXInputManager.h"
#import "JXObjc.h"
#import <objc/runtime.h>

#define kJXInputManagerCategoryLimitKey        @"kJXInputManagerCategoryLimitKey"

static NSMutableDictionary *limitDict;

@implementation UITextField (JXInputManagerCategory)
- (id)valueForUndefinedKey:(NSString *)key {
    if ([key isEqualToString:kJXInputManagerCategoryLimitKey]) {
        if (!JXiOSVersionGreaterThanOrEqual(@"7.0")) {
            return [limitDict objectForKey:[NSString stringWithFormat:@"%p", self]];
        }else {
            return objc_getAssociatedObject(self, key.UTF8String);
        }
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:kJXInputManagerCategoryLimitKey]) {
        if (!JXiOSVersionGreaterThanOrEqual(@"7.0")) {
            [limitDict setObject:value forKey:[NSString stringWithFormat:@"%p", self]];
        }else {
            objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN);
        }
    }
}

- (void)exSetupLimit:(NSUInteger)limit {
    [self setValue:[NSNumber numberWithUnsignedInteger:limit] forKey:kJXInputManagerCategoryLimitKey];
}

//- (void)clearLimit {
//    [limitDict removeObjectForKey:[NSString stringWithFormat:@"%p", self]];
//}
@end


@implementation UITextView (JXInputManagerCategory)
- (id)valueForUndefinedKey:(NSString *)key {
    if ([key isEqualToString:kJXInputManagerCategoryLimitKey]) {
        if (!JXiOSVersionGreaterThanOrEqual(@"7.0")) {
            return [limitDict objectForKey:[NSString stringWithFormat:@"%p", self]];
        }else {
            return objc_getAssociatedObject(self, key.UTF8String);
        }
    }
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:kJXInputManagerCategoryLimitKey]) {
        if (!JXiOSVersionGreaterThanOrEqual(@"7.0")) {
            [limitDict setObject:value forKey:[NSString stringWithFormat:@"%p", self]];
        }else {
            objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN);
        }
    }
}

- (void)exSetupLimit:(NSUInteger)limit {
    [self setValue:[NSNumber numberWithUnsignedInteger:limit] forKey:kJXInputManagerCategoryLimitKey];
}

//- (void)clearLimit {
//    [limitDict removeObjectForKey:[NSString stringWithFormat:@"%p", self]];
//}
@end


@interface JXInputManager ()
@property (nonatomic, copy) void(^exceedBlock)(UIView *inputView, NSUInteger exceed);
@property (nonatomic, copy) void(^countBlock)(UIView *inputView, NSUInteger count);
@end

@implementation JXInputManager
+ (void)load {
    [super load];
    if (!JXiOSVersionGreaterThanOrEqual(@"7.0")) {
        limitDict = [NSMutableDictionary dictionary];
    }
    [JXInputManager sharedInstance];
}

+ (JXInputManager *)sharedInstance {
    static JXInputManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JXInputManager alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.enable = YES;
    }
    return self;
}

- (void)setEnable:(BOOL)enable {
    if (_enable == enable) {
        return;
    }
    
    if (enable) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidChange:) name:UITextFieldTextDidChangeNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object: nil];
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    _enable = enable;
}

- (void)setupExceedBlock:(void(^)(UIView *inputView, NSUInteger exceed))exceedBlock
              countBlock:(void(^)(UIView *inputView, NSUInteger count))countBlock {
    if (!JXiOSVersionGreaterThanOrEqual(@"7.0") && !exceedBlock && !countBlock) {
        [limitDict removeAllObjects];
    }
    
    _exceedBlock = exceedBlock;
    _countBlock = countBlock;
}

- (void)textFieldViewDidChange:(NSNotification*)notification {
    UITextField *textField = (UITextField *)notification.object;
    
    NSNumber *number;
    if (!JXiOSVersionGreaterThanOrEqual(@"7.0")) {
        number = [limitDict objectForKey:[NSString stringWithFormat:@"%p", textField]];
    }else {
        number = [textField valueForKey:kJXInputManagerCategoryLimitKey];
    }
    if (!number) {
        return;
    }
    
    UITextRange *textRange = textField.markedTextRange;
    if (textRange) {
        return;
    }
    
    NSUInteger limit = number.unsignedIntegerValue;
    NSUInteger chars;
    if (JXInputManagerLimitDistinguish == _type) {
        chars = [textField.text exLengthInByte];
    }else {
        chars = textField.text.length;
    }
    if (chars > limit) {
        NSInteger adjust = limit;
        if (chars == limit + 1) {
            NSString *subString = [textField.text substringWithRange:NSMakeRange(limit - 1, 1)];
            const char *cString = [subString UTF8String];
            if (NULL == cString) {
                adjust -= 1;
            }
        }
        
        if (JXInputManagerLimitDistinguish == _type) {
            textField.text = [textField.text exSubstringWithByteCount:adjust];
        }else {
            textField.text = [textField.text substringToIndex:adjust];
        }
        
        if (_exceedBlock) {
            _exceedBlock(textField, limit);
        }
    }
    
    if (JXInputManagerLimitDistinguish == _type) {
        chars = [textField.text exLengthInByte];
    }else {
        chars = textField.text.length;
    }
    
    if (_countBlock) {
        _countBlock(textField,chars);
    }
}

- (void)textViewDidChange:(NSNotification *)notification {
    UITextView *textView = (UITextView *)notification.object;
    
    NSNumber *number;
    if (!JXiOSVersionGreaterThanOrEqual(@"7.0")) {
        number = [limitDict objectForKey:[NSString stringWithFormat:@"%p", textView]];
    }else {
        number = [textView valueForKey:kJXInputManagerCategoryLimitKey];
    }
    if (!number) {
        return;
    }
    
    UITextRange *textRange = textView.markedTextRange;
    if (textRange) {
        return;
    }
    
    NSUInteger limit = number.unsignedIntegerValue;
    NSUInteger chars;
    if (JXInputManagerLimitDistinguish == _type) {
        chars = [textView.text exLengthInByte];
    }else {
        chars = textView.text.length;
    }
    if (chars > limit) {
        NSInteger adjust = limit;
        if (chars == limit + 1) {
            NSString *subString = [textView.text substringWithRange:NSMakeRange(limit - 1, 1)];
            const char *cString = [subString UTF8String];
            if (NULL == cString) {
                adjust -= 1;
            }
        }
        
        if (JXInputManagerLimitDistinguish == _type) {
            textView.text = [textView.text exSubstringWithByteCount:adjust];
        }else {
            textView.text = [textView.text substringToIndex:adjust];
        }
        
        if (_exceedBlock) {
            _exceedBlock(textView, limit);
        }
    }
    
    if (JXInputManagerLimitDistinguish == _type) {
        chars = [textView.text exLengthInByte];
    }else {
        chars = textView.text.length;
    }
    
    if (_countBlock) {
        _countBlock(textView, chars);
    }
}

#pragma mark - Class methods
//NSString * VerifyPhonenumber(NSString *phonenumber) {
//}

+ (NSString *)verifyPhone:(NSString *)phone original:(NSString *)original {
    if (0 == [phone exTrimWhitespaceAndNewline].length) {
        return kStringPleaseInputValidPhone;
    }
    
    if ([phone isEqualToString:original]) {
        return kStringPhoneNumberNeedNotSame;
    }
    
    NSString *regex = @"^1[3-9][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:phone];
    
    return isValid ? nil : kStringPleaseInputValidPhone;
}

+ (NSString *)verifyEmail:(NSString *)email original:(NSString *)original {
    if (0 == [email exTrimWhitespaceAndNewline].length) {
        return kStringPleaseInputValidEmail;
    }
    
    if ([email isEqualToString:original]) {
        return kStringEmailNeedNotSame;
    }
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:email];
    
    return isValid ? nil : kStringPleaseInputValidEmail;
}

+ (NSString *)verifyInput:(NSString *)input
                    least:(NSInteger)least
                 original:(NSString *)original
                    title:(NSString *)title {
    NSString *myTitle = JXDataIsEmpty(title) ? @"" : title;
    // 不能为空
    if (0 == input.length) {
        return [NSString stringWithFormat:@"%@不能为空", myTitle];
    }
    
    // 不能全为空白字符
    if (0 == [input exTrimWhitespaceAndNewline].length) {
        return [NSString stringWithFormat:@"%@不能全为空白字符", myTitle];
    }
    
    // 至少输入
    if (input.length < least) {
        return [NSString stringWithFormat:@"%@至少为%@位", myTitle, @(least)];
    }
    
    // 不能相同
    if ([input isEqualToString:original]) {
        return [NSString stringWithFormat:@"请输入与原%@不一样的新%@", myTitle, myTitle];
    }
    
    return nil;
}

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
                  message:(NSString *)message {
    NSString *myTitle = JXDataIsEmpty(title) ? @"" : title;
    NSString *myMessage = JXDataIsEmpty(message) ? @"" : message;
    
    // 不能为空
    if (0 == input.length) {
        return [NSString stringWithFormat:@"%@不能为空", myTitle];
    }
    
    // 不能全为空白字符
    if (0 == [input exTrimWhitespaceAndNewline].length) {
        return [NSString stringWithFormat:@"%@不能全为空白字符", myTitle];
    }
    
    // 至少输入
    if (input.length < least) {
        return [NSString stringWithFormat:@"%@至少为%@位", myTitle, @(least)];
    }
    
    // 不能相同
    if ([input isEqualToString:original]) {
        return [NSString stringWithFormat:@"请输入与原%@不一样的新%@", myTitle, myTitle];
    }
    
    // 起始字符必须为
    if (!JXDataIsEmpty(mustPrefix)) {
        NSString *first = [input substringToIndex:1];
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:mustPrefix];
        NSRange range = [first rangeOfCharacterFromSet:charSet];
        if (range.location == NSNotFound) {
            return myMessage;
        }
    }
    
    // 结尾字符必须为
    if (!JXDataIsEmpty(mustSuffix)) {
        NSString *last = [input substringFromIndex:(input.length - 1)];
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:mustSuffix];
        NSRange range = [last rangeOfCharacterFromSet:charSet];
        if (range.location == NSNotFound) {
            return myMessage;
        }
    }
    
    // 必须为
    if (!JXDataIsEmpty(mustSymbols)) {
        NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:mustSymbols] invertedSet];
        NSRange range = [input rangeOfCharacterFromSet:charSet];
        if (range.location != NSNotFound) {
            return myMessage;
        }
    }
    
    // 起始字符不能为
    if (!JXDataIsEmpty(cantPrefix)) {
        NSString *first = [input substringToIndex:1];
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:cantPrefix];
        NSRange range = [first rangeOfCharacterFromSet:charSet];
        if (range.location != NSNotFound) {
            return myMessage;
        }
    }
    
    // 结尾字符不能为
    if (!JXDataIsEmpty(cantSuffix)) {
        NSString *last = [input substringFromIndex:(input.length - 1)];
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:cantSuffix];
        NSRange range = [last rangeOfCharacterFromSet:charSet];
        if (range.location != NSNotFound) {
            return myMessage;
        }
    }
    
    // 不能为
    if (!JXDataIsEmpty(cantSymbols)) {
        NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:cantSymbols] invertedSet];
        NSRange range = [input rangeOfCharacterFromSet:charSet];
        if (range.location == NSNotFound) {
            return myMessage;
        }
    }
    
    return nil;
}



//+ (NSString *)verifyInput:(NSString *)input
//                    least:(NSInteger)least
//                 original:(NSString *)original
//                 ltSpaces:(BOOL)ltSpaces
//                  symbols:(NSString *)symbols
//                    title:(NSString *)title
//                  message:(NSString *)message {
//    if (title.length == 0 || message.length == 0) {
//        return @"参数错误，请输入title和message";
//    }
//
//    // 不能为空
//    if (0 == input.length) {
//        return [NSString stringWithFormat:@"请输入%@", title];
//    }
//
//    // 输入不能全为空白字符
//    if (0 == [input exTrim].length) {
//        return message;
//    }
//
//    // 至少输入
//    if (input.length < least) {
//        return [NSString stringWithFormat:@"%@至少为%@位", title, @(least)];
//    }
//
//    // 不能相同
//    if ([[input exTrim] isEqualToString:[original exTrim]]) {
//        return [NSString stringWithFormat:@"请输入与原%@不一样的新%@", title, title];
//    }
//
//    // 首尾不能包含空白字符
//    if (!ltSpaces) {
//        NSString *first = [input substringToIndex:1];
//        NSString *last = [input substringFromIndex:(input.length - 1)];
//        NSCharacterSet *wnSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//
//        NSRange range = [first rangeOfCharacterFromSet:wnSet];
//        if (range.location != NSNotFound) {
//            return [NSString stringWithFormat:@"%@首尾不能包含空白字符", title];
//        }
//
//        range = [last rangeOfCharacterFromSet:wnSet];
//        if (range.location != NSNotFound) {
//            return [NSString stringWithFormat:@"%@首尾不能包含空白字符", title];
//        }
//    }
//
//    // 纯英文
//    if (symbols.length != 0) {
//        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:symbols] invertedSet];
//        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
//        if (range.location != NSNotFound) {
//            return message;
//        }
//    }
//
//    return nil;
//}
//
//
//+ (NSString *)verifyInput:(NSString *)input
//                    least:(NSInteger)least
//                 original:(NSString *)original
//                 ltSpaces:(BOOL)ltSpaces
//           containLetters:(BOOL)containLetters
//           containNumbers:(BOOL)containNumbers
//                    title:(NSString *)title {
//    // 不能为空
//    if (0 == input.length) {
//        return [NSString stringWithFormat:@"%@不能为空", title];
//    }
//
//    // 输入不能全为空白字符
//    if (0 == [input exTrim].length) {
//        return [NSString stringWithFormat:@"%@不能全为空白字符", title];
//    }
//
//    // 至少输入
//    if (input.length < least) {
//        return [NSString stringWithFormat:@"%@至少为%@位", title, @(least)];
//    }
//
//    // 不能相同
//    if ([[input exTrim] isEqualToString:[original exTrim]]) {
//        return [NSString stringWithFormat:@"请输入与原%@不一样的新%@", title, title];
//    }
//
//    // 首尾不能包含空白字符
//    if (!ltSpaces) {
//        NSString *first = [input substringToIndex:1];
//        NSString *last = [input substringFromIndex:(input.length - 1)];
//        NSCharacterSet *wnSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//
//        NSRange range = [first rangeOfCharacterFromSet:wnSet];
//        if (range.location != NSNotFound) {
//            return [NSString stringWithFormat:@"%@首尾不能包含空白字符", title];
//        }
//
//        range = [last rangeOfCharacterFromSet:wnSet];
//        if (range.location != NSNotFound) {
//            return [NSString stringWithFormat:@"%@首尾不能包含空白字符", title];
//        }
//    }
//
//    // 纯英文
//    if (containLetters && !containNumbers) {
//        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
//        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
//        if (range.location != NSNotFound) {
//            return [NSString stringWithFormat:@"%@只能包含英文字母", title];
//        }
//    }
//
//    // 纯数字
//    if (!containLetters && containNumbers) {
//        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
//        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
//        if (range.location != NSNotFound) {
//            [NSString stringWithFormat:@"%@只能包含数字", title];
//        }
//    }
//
//    // 纯英文+数字
//    if (containLetters && containNumbers) {
//        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
//        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
//        if (range.location != NSNotFound) {
//            return [NSString stringWithFormat:@"%@只能包含字母和数字", title];
//        }
//    }
//
//    return nil;
//}
//
//+ (NSString *)verifyInput:(NSString *)input
//                    least:(NSInteger)least
//                 original:(NSString *)original
//            spacesAllowed:(BOOL)spacesAllowed
//                pureChars:(BOOL)pureChars
//                 pureNums:(BOOL)pureNums
//                     name:(NSString *)name {
//    JXInputManagerVerify verify = [[self class] verifyInput:input
//                                                      least:least
//                                                   original:original
//                                              spacesAllowed:spacesAllowed
//                                                  pureChars:pureChars
//                                                   pureNums:pureNums];
//    NSString *result = nil;
//    switch (verify) {
//        case JXInputManagerVerifyNeed:
//            result = [NSString stringWithFormat:@"%@不能为空", name];
//            break;
//        case JXInputManagerVerifyWhitespaceLT:
//            result = [NSString stringWithFormat:@"%@首尾不能包含空白字符", name];
//            break;
//        case JXInputManagerVerifyWhitespaceAll:
//            result = [NSString stringWithFormat:@"%@不能全为空白字符", name];
//            break;
//        case JXInputManagerVerifyPureChars:
//            result = [NSString stringWithFormat:@"%@只能包含英文字符", name];
//            break;
//        case JXInputManagerVerifyPureNums:
//            result = [NSString stringWithFormat:@"%@只能包含数字", name];
//            break;
//        case JXInputManagerVerifyPureASCII:
//            result = [NSString stringWithFormat:@"%@只能包含英文和数字", name];
//            break;
//        case JXInputManagerVerifyLeast:
//            result = [NSString stringWithFormat:@"%@至少为%@位", name, @(least)];
//            break;
//        case JXInputManagerVerifySame:
//            result = [NSString stringWithFormat:@"请输入与原%@不一样的新%@", name, name];
//            break;
//        default:
//            break;
//    }
//    return result;
//}
//
//+ (JXInputManagerVerify)verifyInput:(NSString *)input
//                              least:(NSInteger)least
//                           original:(NSString *)original
//                      spacesAllowed:(BOOL)spacesAllowed
//                          pureChars:(BOOL)pureChars
//                           pureNums:(BOOL)pureNums {
//    // 不能为空
//    if (0 == input.length) {
//        return JXInputManagerVerifyNeed;
//    }
//
//    // 首尾不能包含空白字符
//    if (!spacesAllowed && (input.length >= 1)) {
//        NSString *first = [input substringToIndex:1];
//        NSString *last = [input substringFromIndex:(input.length - 1)];
//        NSCharacterSet *wnSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//
//        NSRange range = [first rangeOfCharacterFromSet:wnSet];
//        if (range.location != NSNotFound) {
//            return JXInputManagerVerifyWhitespaceLT;
//        }
//
//        range = [last rangeOfCharacterFromSet:wnSet];
//        if (range.location != NSNotFound) {
//            return JXInputManagerVerifyWhitespaceLT;
//        }
//    }
//
//    // 输入不能全为空白字符
//    NSString *pure = [input exTrim];
//    if (0 == pure.length) {
//        return JXInputManagerVerifyWhitespaceAll;
//    }
//
//    // 纯英文
//    if (pureChars && !pureNums) {
//        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
//        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
//        if (range.location != NSNotFound) {
//            return JXInputManagerVerifyPureChars;
//        }
//    }
//
//    // 纯数字
//    if (!pureChars && pureNums) {
//        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
//        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
//        if (range.location != NSNotFound) {
//            return JXInputManagerVerifyPureChars;
//        }
//    }
//
//    // 纯英文+数字
//    if (pureChars && pureNums) {
//        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
//        NSRange range = [input rangeOfCharacterFromSet:allowedCharacters];
//        if (range.location != NSNotFound) {
//            return JXInputManagerVerifyPureChars;
//        }
//    }
//
//    // 至少输入
//    if (input.length < least) {
//        return JXInputManagerVerifyLeast;
//    }
//
//    // 不能相同
//    if ([pure isEqualToString:[original exTrim]]) {
//        return JXInputManagerVerifySame;
//    }
//
//    return JXInputManagerVerifyNone;
//}
@end
