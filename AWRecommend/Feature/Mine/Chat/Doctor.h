//
//  Doctor.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/11.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

//"doctorId": "D40",
//"doctorName": "继续",
//"avatar": "http://img-test.appvworks.com/739c2a5f0b6c41a78ef3d289ab172b8b"
@interface Doctor : JXObject
@property (nonatomic, copy) NSString *doctorId;
@property (nonatomic, copy) NSString *doctorName;
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, strong) UIImage *dImage;
@property (nonatomic, strong) UIImage *aImage;

@end
