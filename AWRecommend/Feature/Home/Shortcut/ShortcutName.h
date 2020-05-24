//
//  ShortcutName.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/18.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXObject.h"

@class ShortcutNameList;
@class ShortcutNameListItem;


@interface ShortcutName : JXObject
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *unavatar;
@property (nonatomic, strong) NSDictionary *sortedDrugs;

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSError *error;

@end


@interface ShortcutNameList : JXObject
@property (nonatomic, strong) NSArray *A;
@property (nonatomic, strong) NSArray *B;
@property (nonatomic, strong) NSArray *C;
@property (nonatomic, strong) NSArray *D;
@property (nonatomic, strong) NSArray *E;
@property (nonatomic, strong) NSArray *F;
@property (nonatomic, strong) NSArray *G;
@property (nonatomic, strong) NSArray *H;
@property (nonatomic, strong) NSArray *I;
@property (nonatomic, strong) NSArray *J;
@property (nonatomic, strong) NSArray *K;
@property (nonatomic, strong) NSArray *L;
@property (nonatomic, strong) NSArray *M;
@property (nonatomic, strong) NSArray *N;
@property (nonatomic, strong) NSArray *O;
@property (nonatomic, strong) NSArray *P;
@property (nonatomic, strong) NSArray *Q;
@property (nonatomic, strong) NSArray *R;
@property (nonatomic, strong) NSArray *S;
@property (nonatomic, strong) NSArray *T;
@property (nonatomic, strong) NSArray *U;
@property (nonatomic, strong) NSArray *V;
@property (nonatomic, strong) NSArray *W;
@property (nonatomic, strong) NSArray *X;
@property (nonatomic, strong) NSArray *Y;
@property (nonatomic, strong) NSArray *Z;

@end


@interface ShortcutNameListItem : JXObject
@property (nonatomic, copy) NSString *drugName;

@end



