//
//  Type.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/30.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#ifndef Type_h
#define Type_h

typedef NS_ENUM(NSInteger, ApiTag){
    ApiTagNone,
    ApiTagUserInfo,
    ApiTagFavoriteDel,
    ApiTagFavoriteMedicine,
    ApiTagFavoriteArticle,
    ApiTagTotal
};

typedef NS_ENUM(NSInteger, GenderType){
    GenderTypeNone,
    GenderTypeMale,
    GenderTypeFemale
};

typedef NS_ENUM(NSInteger, SearchClassifyType){
    SearchClassifyNone,
    SearchClassifyChildrenSickness,
    SearchClassifyChildrenMedicine,
    SearchClassifyAdultSickness,
    SearchClassifyAdultMedicine,
    SearchClassifyTotal
};

typedef NS_ENUM(NSInteger, SearchKind){
    SearchKindNone,
    SearchKindSickness,
    SearchKindMedicine,
    SearchKindTotal
};

typedef NS_ENUM(NSInteger, PeopleType){
    PeopleTypeNone,
    PeopleTypeChild,
    PeopleTypeAdult,
    PeopleTypeTotal
};

typedef NS_ENUM(NSInteger, NatureType){
    NatureTypeNone,
    NatureTypeXiyao,
    NatureTypeZhongyao,
    NatureTypeOther = 100,
    NatureTypeTotal
};

typedef NS_ENUM(NSInteger, MedicineTag){
    MedicineTagNone,
    MedicineTagProtect,
    MedicineTagPatent,
    MedicineTagBasic
};

typedef NS_ENUM(NSInteger, ShortcutType){
    ShortcutTypeNone,
    ShortcutTypeSymptom,
    ShortcutTypeName
};

#endif /* Type_h */







