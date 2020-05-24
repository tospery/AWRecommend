//
//  NiceComment.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

//"id": 10,
//"articleCommentsTime": "2017-06-21 16:00:19",
//"articleCommentsContext": "aaaaaa",
//"deleteTag": 0,
//"userId": 14,
//"articleId": 3,

@class NiceCommentUser;

@interface NiceComment : JXObject
@property (nonatomic, assign) NSInteger lc;
@property (nonatomic, assign) BOOL deleteTag;
@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, copy) NSString *articleCommentsTime;
@property (nonatomic, copy) NSString *articleCommentsContext;
@property (nonatomic, strong) NiceCommentUser *user;

@end


@interface NiceCommentUser : JXUser
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *dateOfBirth;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *sig;
@property (nonatomic, assign) GenderType sex;

- (NSString *)displayName;

@end
