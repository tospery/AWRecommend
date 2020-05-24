//
//  MytestRecordView.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/12/14.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MytestRecordView.h"
#import "MytestResult.h"

@interface MytestRecordView ()

@end

@implementation MytestRecordView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tableView registerClass:[JXCell class] forCellReuseIdentifier:[JXCell identifier]];
//    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
    self.tableView.tableFooterView = [UIView new];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self jx_borderWithColor:[UIColor clearColor] width:1.0 radius:6.0];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXCell *cell = [tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
    cell.separatorImageView.hidden = YES;
    cell.rightLabel.hidden = NO;
   // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MytestResult *r = self.records[indexPath.row];
    cell.textLabel.font = JXFont(12);
    cell.textLabel.textColor = JXColorHex(0x333333);
    cell.textLabel.text = r.physicalName;
    cell.rightLabel.font = JXFont(12);
    cell.rightLabel.text = [r.createTime substringToIndex:10];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 36;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
//    //    header.contentView.backgroundColor = [UIColor whiteColor];
//    //    header.textLabel.text = @"历史测试记录";
//    //    header.textLabel.font = JXFont(13);
//    //    header.textLabel.textColor = JXColorHex(0x3D8158);
//
//    UIView *bgView = [[[NSBundle mainBundle] loadNibNamed:@"MytestRecordTitleView" owner:nil options:nil] firstObject];
//    [header addSubview:bgView];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(header);
//    }];
//
//
//    return header;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MytestResult *r = self.records[indexPath.row];
//    self.mytz = r.physicalName;
//    [self configResult];
    //[KLCPopup dismissAllPopups];
    if (self.closeBlock) {
        self.closeBlock(r);
    }
}

@end







