//
//  MytestRecordView.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/12/14.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MytestRecordView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *records;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) JXVoidBlock_id closeBlock;

@end
