//
//  SearchClassify.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/22.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

//"categoryName": "儿童",
//"id": 1,
//"type": 2,
//"kind": 1

@interface SearchClassify : JXObject
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) SearchKind kind;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *avatar;


@end
