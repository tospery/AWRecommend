//
//  JXHTTPRequestParam.h
//  AWKSZhixuan
//
//  Created by 杨建祥 on 2017/7/21.
//  Copyright © 2017年 艾维科思. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXHTTPRequestParam : NSObject
@property (nonatomic, strong) id data;

@property (nonatomic, strong) NSDictionary *query;
@property (nonatomic, strong) NSDictionary *header;
@property (nonatomic, strong) NSDictionary *formURLEncoded;
@property (nonatomic, strong) NSDictionary *formData;
@property (nonatomic, strong) NSDictionary *rawJSON;

- (NSDictionary *)commonQuery;
- (NSDictionary *)commonHeader;
- (NSDictionary *)commonFormURLEncoded;
- (NSDictionary *)commonFormData;
- (NSDictionary *)commonRawJSON;

@end
