//
//  Favorite.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/3.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

@interface Favorite : JXObject
@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *drugName;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *createDate;

@end
