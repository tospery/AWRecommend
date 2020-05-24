//
//  NiceList.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/6/14.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "NiceList.h"

@implementation NiceList
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"currPage": @"currentPage",
             @"totalPage": @"totalPages",
             @"totalSize": @"totalRows",
             @"datas": @"data"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"datas": [Nice class]};
}

@end


@implementation Nice
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"wiseExcellentArticleRelatedDiscountDtos": [NiceRelate class],
             @"wiseExcellentTagsDtos": [NiceTag class],
             @"wiseExcellentArticleBuyAcessDtos": [NiceBuy class]};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"articleDetailsImages"]) {
        NSArray *arr = [(NSString *)oldValue componentsSeparatedByString:@","];
        NSMutableArray *ret = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSString *link in arr) {
            if (link.length >= 7) {
                [ret addObject:link];
            }
        }
        return ret;
    }
    return oldValue;
}

@end

@implementation NiceRelate

@end

@implementation NiceTag

@end

@implementation NiceBuy

@end
