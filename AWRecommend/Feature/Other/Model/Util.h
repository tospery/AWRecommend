//
//  Util.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/4.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+ (NSString *)stringWithSearchClassify:(SearchClassifyType)classify;
+ (BOOL)isMedicineWithSearchClassify:(SearchClassifyType)classify;

+ (NSString *)stringWithPeopleType:(PeopleType)type;
+ (NSString *)stringWithNatureType:(NatureType)type;

+ (NSString *)securityWithValue:(CGFloat)value;
+ (NSString *)stabilityWithValue:(CGFloat)value;
+ (NSString *)stringWithSearchKind:(SearchKind)kind;
+ (NSString *)titleWithSearchKind:(SearchKind)kind;

@end

NSString * GenderTypeString(GenderType t);
NSString * MedicineTagString(MedicineTag num);
UIColor * MedicineTagColor(MedicineTag num);
NSString * ShortcutTypeString(ShortcutType type);

void EntryScan(UINavigationController *nav);
RACCommand * EntryChat(JXViewController *vc);





