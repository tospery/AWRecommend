//
//  SearchResultViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/16.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXViewController.h"

@interface SearchResultViewController : JXTableViewController
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString *searchScope;
@property (nonatomic, assign) BOOL fromTJ;

//@property (nonatomic, assign) PeopleType type;

@end
