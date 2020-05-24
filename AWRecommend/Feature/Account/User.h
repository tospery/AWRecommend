//
//  User.h
//  AWRecommend
//
//  Created by 杨建祥 on 16/12/27.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXUser.h"

//"id": 4,
//"mobile": "18981974113",
//"nickName": null,
//"sex": null,
//"dateOfBirth": null,
//"avatar": null

@interface User : JXUser
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *dateOfBirth;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *sig;
@property (nonatomic, assign) GenderType sex;

- (NSString *)displayName;

@end
