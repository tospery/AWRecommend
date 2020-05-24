//
//  ResultCardView.m
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/15.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ResultCardView.h"
#import "ResultCardCell.h"

@interface ResultCardView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *title1Label;
@property (nonatomic, weak) IBOutlet UILabel *title2Label;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIView *countBgLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
//@property (nonatomic, weak) IBOutlet TTTAttributedLabel *chineseMedicineLabel;
//@property (nonatomic, weak) IBOutlet TTTAttributedLabel *westernMedicineLabel;

@property (nonatomic, weak) IBOutlet UILabel *chineseTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *chineseCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *westernTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *westernCountLabel;

@property (nonatomic, weak) IBOutlet JXButton *moreButton;
@property (nonatomic, weak) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIView *emptyView;

@end

@implementation ResultCardView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, JXScreenScale(280), JXScreenScale(310));
    //self.frame = CGRectMake(0, 0, JXScreenScale(200), JXScreenScale(120));
    
    self.title1Label.font = JXFont(14);
    self.countLabel.font = JXFont(10);
    self.title2Label.font = JXFont(16);
    
    self.chineseTitleLabel.font = JXFont(14);
    self.chineseCountLabel.font = JXFont(22);
    self.westernTitleLabel.font = JXFont(14);
    self.westernCountLabel.font = JXFont(22);
    
    JXAdaptButton(self.moreButton, JXFont(12));
    self.moreButton.style = JXButtonStyleRight;
    self.moreButton.distance = 4.0;
    
    UINib *nib = [UINib nibWithNibName:@"ResultCardCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[ResultCardCell identifier]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
    [self.countBgLabel jx_borderWithColor:[UIColor clearColor] width:0.0 radius:8.0];
}

- (void)setList:(CompResultList *)list {
    _list = list;
    
    NSString *title = JXStrWithFmt(@"%@药品", list.groupValue);
    self.title1Label.text = title;
    self.title2Label.text = title;
    
    NSString *count = list.totalSize >= 99 ? @"99+" : JXStrWithInt(list.totalSize);
    self.countLabel.text = count;
    
    NSString *more = JXStrWithFmt(@"更多%ld种药品", (long)list.totalSize);
    [self.moreButton setTitle:more forState:UIControlStateNormal];
    
    // YJX_TODO 缺少头像
    [self.avatarImageView sd_setImageWithURL:JXURLWithStr(list.avatar) placeholderImage:JXImageWithName(@"img_head_default")];
    
    [self.chineseCountLabel jx_animateCountWithDuration:1.0 count:list.chineseDrugCount isInt:YES format:@"%ld"];
    [self.westernCountLabel jx_animateCountWithDuration:1.0 count:list.westernDrugCount isInt:YES format:@"%ld"];
    
//    NSString *cText = JXStrWithFmt(@"中成药\n%ld", (long)list.chineseDrugCount);
//    NSMutableAttributedString *cAttr = [NSMutableAttributedString jx_attributedStringWithString:cText color:[UIColor whiteColor] font:JXFont(13)];
//    [cAttr jx_addAttributeWithColor:[UIColor whiteColor] font:JXFont(20) range:NSMakeRange(4, cText.length - 4)];
//    self.chineseMedicineLabel.text = cAttr;
//    
//    
//    NSString *wText = JXStrWithFmt(@"西药\n%ld", (long)list.westernDrugCount);
//    NSMutableAttributedString *wAttr = [NSMutableAttributedString jx_attributedStringWithString:wText color:[UIColor whiteColor] font:JXFont(13)];
//    [wAttr jx_addAttributeWithColor:[UIColor whiteColor] font:JXFont(20) range:NSMakeRange(3, wText.length - 3)];
//    self.westernMedicineLabel.text = wAttr;
    
    
    // YJX_TODO整理到JX中
//    NSString *animName = @"zcyCountAnimation";
//    [self.chineseMedicineLabel pop_removeAnimationForKey:animName];
//    
//    POPBasicAnimation *anim = [POPBasicAnimation animation];
//    anim.duration = 1.0;
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    POPAnimatableProperty * prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
//        prop.readBlock = ^(id obj, CGFloat values[]) {
//            values[0] = [[obj description] floatValue];
//        };
//        prop.writeBlock = ^(id obj, const CGFloat values[]) {
//            NSString *cText = JXStrWithFmt(@"中成药\n%ld", (long)values[0]);
//            NSMutableAttributedString *cAttr = [NSMutableAttributedString jx_attributedStringWithString:cText color:[UIColor whiteColor] font:JXFont(13)];
//            [cAttr jx_addAttributeWithColor:[UIColor whiteColor] font:JXFont(20) range:NSMakeRange(4, cText.length - 4)];
//            [obj setText:cText];
//        };
//        prop.threshold = 0.01;
//    }];
//
//    anim.property = prop;
//    anim.fromValue = @(0);
//    anim.toValue = @(177/*list.chineseDrugCount*/);
//    [self.chineseMedicineLabel pop_addAnimation:anim forKey:animName];
//    
//    
//    animName = @"xyCountAnimation";
//    [self.westernMedicineLabel pop_removeAnimationForKey:animName];
//    
//    anim = [POPBasicAnimation animation];
//    anim.duration = 1.0;
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    prop = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
//        prop.readBlock = ^(id obj, CGFloat values[]) {
//            values[0] = [[obj description] floatValue];
//        };
//        prop.writeBlock = ^(id obj, const CGFloat values[]) {
//            NSString *cText = JXStrWithFmt(@"西药\n%ld", (long)values[0]);
//            NSMutableAttributedString *cAttr = [NSMutableAttributedString jx_attributedStringWithString:cText color:[UIColor whiteColor] font:JXFont(13)];
//            [cAttr jx_addAttributeWithColor:[UIColor whiteColor] font:JXFont(20) range:NSMakeRange(4, cText.length - 4)];
//            [obj setText:cText];
//        };
//        prop.threshold = 0.01;
//    }];
//    
//    anim.property = prop;
//    anim.fromValue = @(0);
//    anim.toValue = @(list.westernDrugCount);
//    [self.westernMedicineLabel pop_addAnimation:anim forKey:animName];
    
    if (list.datas.count == 0) {
        self.emptyView.hidden = NO;
    }else {
        self.emptyView.hidden = YES;
    }
    
    if (list.datas.count <= 3) {
        self.footerView.hidden = YES;
    }else {
        self.footerView.hidden = NO;
    }
    
    [self.tableView reloadData];
}

- (IBAction)moreButtonPressed:(id)sender {
    if (self.moreBlock) {
        self.moreBlock(RACTuplePack(self.list.keyword, self.list.groupValue));
    }
}

- (IBAction)zyButtonPressed:(id)sender {
    if (self.zyBlock) {
        self.zyBlock(RACTuplePack(self.list.keyword, self.list.groupValue));
    }
}

- (IBAction)xyButtonPressed:(id)sender {
    if (self.xyBlock) {
        self.xyBlock(RACTuplePack(self.list.keyword, self.list.groupValue));
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.list.datas.count;
    if (count <= 3) {
        self.footerView.frame = CGRectMake(0, 0, JXScreenScale(280), 0);
        return count;
    }
    
    self.footerView.frame = CGRectMake(0, 0, JXScreenScale(280), JXScreenScale(30));
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JXScreenScale(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultCardCell *cell = [tableView dequeueReusableCellWithIdentifier:[ResultCardCell identifier] forIndexPath:indexPath];
    CompResultItem *item = self.list.datas[indexPath.row];
    cell.data = item;
    cell.matchBlock = self.matchBlock;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CompResultItem *item = self.list.datas[indexPath.row];
    if (self.itemBlock) {
        self.itemBlock(item);
    }
}


@end






