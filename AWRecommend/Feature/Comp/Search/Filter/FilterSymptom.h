//
//  FilterSymptom.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/4/24.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

//"id": 73,
//"drugCategoryName": "小儿感冒发烧",
//"tag": "神经衰弱,腹泻,小儿疼痛",
//"disease": [
//            "神经衰弱",
//            "腹泻",
//            "小儿疼痛"
//            ]

@interface FilterSymptom : JXObject
@property (nonatomic, copy) NSString *drugCategoryName;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSArray *disease;

@end
