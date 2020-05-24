//
//  ShortcutSymptom.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/19.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

@class ShortcutSymptomList;

@interface ShortcutSymptom : JXObject
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *unavatar;
@property (nonatomic, strong) NSArray *disease;
@property (nonatomic, strong) NSError *error;

@end


@interface ShortcutSymptomList : JXObject
@property (nonatomic, copy) NSString *drugCategoryName;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSArray *disease;

@end


@interface ShortcutSymptomListDisease : JXObject
@property (nonatomic, copy) NSString *tag;

@end


