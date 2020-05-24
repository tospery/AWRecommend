//
//  JXActionSelectionContentTable.h
//  JXSamples
//
//  Created by 杨建祥 on 16/6/2.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import "JXActionSelectionContent.h"

@interface JXActionSelectionContentTable : JXActionSelectionContent <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithOptions:(NSArray *)options defaultIndex:(NSInteger)index;

@end