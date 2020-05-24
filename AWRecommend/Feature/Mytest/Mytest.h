//
//  Mytest.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/12/4.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXArchiveObject.h"

@interface Mytest : JXArchiveObject
@property (nonatomic, assign) NSInteger type; // 0 所有  1 男  2 女
@property (nonatomic, copy) NSString *topic;
@property (nonatomic, copy) NSString *physical;
@property (nonatomic, strong) NSArray *answerArr;

@end

@interface MytestAnswer : JXArchiveObject
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger answer;
@property (nonatomic, copy) NSString *reply;

@end
