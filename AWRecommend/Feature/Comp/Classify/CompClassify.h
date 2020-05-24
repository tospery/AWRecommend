//
//  CompClassify.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/1/4.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

@interface CompClassify : JXObject
@property (nonatomic, copy) NSString *drugCategoryName;
@property (nonatomic, strong) NSArray *datas;

@end


@interface CompClassifyData1 : JXObject
@property (nonatomic, assign) NSInteger natureType;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, strong) NSArray *datas;
// 扩展
@property (nonatomic, assign) BOOL selected;

@end

@interface CompClassifyData2 : JXObject
@property (nonatomic, copy) NSString *drugName;

@end
