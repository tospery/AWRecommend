//
//  MytestViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/12/4.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "MytestViewController.h"
#import "MytestIntro.h"
#import "MytestRecordView.h"

@interface MytestViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) RACCommand *saveCommand;
@property (nonatomic, strong) RACCommand *listCommand;

// @property (nonatomic, weak) IBOutlet UIView *tableBgView;
@property (nonatomic, weak) IBOutlet UIView *finishView;
// @property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *finishContraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentContraint;
@property (nonatomic, strong) NSArray *records;
@property (nonatomic, assign) BOOL isFinished;

@property (nonatomic, strong) NSString *mytz;
@property (nonatomic, strong) NSString *mytm;
@property (nonatomic, strong) RACTuple *mytuple;

@property (nonatomic, assign) BOOL isBack;
@property (nonatomic, assign) BOOL onceAnimated;

@property (nonatomic, assign) NSInteger sex; // 0男 1女

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) CGFloat progressStep;
@property (nonatomic, assign) CGFloat progressLength;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *descLabels;
@property (nonatomic, weak) IBOutlet UIButton *startYulanButton;
@property (nonatomic, weak) IBOutlet UIButton *startKaishiButton;
@property (nonatomic, weak) IBOutlet UIView *startView;

@property (nonatomic, weak) IBOutlet UIView *middleView;
@property (nonatomic, weak) IBOutlet UIImageView *middlePBgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *middlePCvImageView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *middlePBzConstraint;
@property (nonatomic, weak) IBOutlet UILabel *stepStartLabel;
@property (nonatomic, weak) IBOutlet UILabel *stepEndLabel;

@property (nonatomic, strong) NSArray *qsts;
@property (nonatomic, strong) NSArray *asrs;
@property (nonatomic, strong) NSMutableDictionary *results;
@property (nonatomic, strong) NSMutableDictionary *resultCounts;
@property (nonatomic, weak) IBOutlet UIView *qstView;
@property (nonatomic, weak) IBOutlet UILabel *qstLabel;

@property (nonatomic, weak) IBOutlet UIView *resultView;
@property (nonatomic, weak) IBOutlet UIButton *resultAgainButton;
@property (nonatomic, weak) IBOutlet UIButton *resultAgainButton2;
@property (nonatomic, weak) IBOutlet UIButton *resultSaveButton;

@property (nonatomic, weak) IBOutlet UIImageView *rLogoImageView;
@property (nonatomic, weak) IBOutlet UILabel *rWhatTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *rWhatLabel;
@property (nonatomic, weak) IBOutlet UILabel *rTodoLabel;
@property (nonatomic, weak) IBOutlet UILabel *rGoodsLabel;
@property (nonatomic, weak) IBOutlet UIButton *rBuyButton;

@property (nonatomic, weak) IBOutlet UILabel *timeOrMyLabel;

@property (nonatomic, assign) BOOL onceAppear;

@property (nonatomic, strong) MytestRecordView *recordView;

@end

@implementation MytestViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        //self.shouldPullToRefresh = YES;
    }
    return self;
}

#pragma mark view
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupView];
    [self setupNet];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if (!self.isFromMine) {
//        self.navigationItem.leftBarButtonItem = nil;
//        [self.navigationItem setHidesBackButton:YES];
//    }
    
    if (!self.onceAppear) {
        self.onceAppear = YES;
    }else {
        if (!self.isFromMine) {
            [self showIfNeedWithLogin];
        }
    }
}

- (void)showIfNeedWithLogin {
    NSArray *items = [TMInstance objectForKey:kTMTestList];
    if (gUser.isLogined && items.count != 0) {
        self.startView.hidden = NO;
        self.middleView.hidden = NO;
        self.resultView.hidden = NO;
        
        self.records = items;
        if (self.recordView) {
            self.recordView.records = items;
            [self.recordView.tableView reloadData];
        }

        MytestResult *r = self.records[0];
        self.mytz = r.physicalName;
        self.mytm = r.createTime;
        [self configResult];
        self.finishView.hidden = NO;
    }else {
        self.startView.hidden = NO;
        self.middleView.hidden = YES;
        self.resultView.hidden = YES;
        
        self.records = nil;
        if (self.recordView) {
            self.recordView.records = self.records;
            [self.recordView.tableView reloadData];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.startYulanButton jx_borderWithColor:JXColorHex(0x3D8158) width:1.0 radius:20.0];
    [self.startKaishiButton jx_borderWithColor:[UIColor clearColor] width:1.0 radius:20.0];
    [self.middlePBgImageView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
    [self.middlePCvImageView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:6.0];
    [self.resultSaveButton jx_borderWithColor:JXColorHex(0x3D8158) width:1.0 radius:20.0];
    [self.resultAgainButton jx_borderWithColor:[UIColor clearColor] width:1.0 radius:20.0];
    [self.resultAgainButton2 jx_borderWithColor:[UIColor clearColor] width:1.0 radius:20.0];
    //[self.tableBgView jx_borderWithColor:[UIColor clearColor] width:1.0 radius:6.0];
}

#pragma mark setup
- (void)setupVar {
    self.results = [NSMutableDictionary dictionaryWithCapacity:10];
    self.resultCounts = [NSMutableDictionary dictionaryWithCapacity:10];
    self.sex = 1;
    self.progressLength = JXAdaptScreenWidth() - JXAdaptScreen(40) - JXAdaptScreen(36);
}

- (void)setupView {
    self.navigationItem.title = @"自测体质";
    
    self.startView.hidden = NO;
    self.middleView.hidden = YES;
    self.resultView.hidden = YES;
    
    NSMutableAttributedString *startMA = [NSMutableAttributedString jx_attributedStringWithString:@"本测试根据2009年4月9日，中华中医药学会发布的《中医体质分类与判定》国家标准而制定。" color:JXColorHex(0xB1B0B0) font:JXFont(10)];
    [startMA jx_addLineSpacing:2 alignment:NSTextAlignmentLeft];
    for (UILabel *l in self.descLabels) {
        l.numberOfLines = 5;
        l.attributedText = startMA;
    }
    
    self.startYulanButton.titleLabel.font = JXFont(16);
    self.startKaishiButton.titleLabel.font = JXFont(16);
    self.resultAgainButton.titleLabel.font = JXFont(16);
    self.resultSaveButton.titleLabel.font = JXFont(16);
    
//    [self.tableView registerClass:[JXCell class] forCellReuseIdentifier:[JXCell identifier]];
//    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kJXIdentifierHeaderFooter];
//    self.tableView.tableFooterView = [UIView new];
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    // RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(NSArray *tests) {
        self.qsts = tests;
        return JXArrEmpty(tests, nil);
    }];
    
    [RACObserve(self, qsts) subscribeNext:^(NSArray *qsts) {
        if (qsts.count != 0) {
            self.total = qsts.count - 1;
            self.progressStep = self.progressLength / (CGFloat)self.total;
            
            [self showIfNeedWithLogin];
        }
    }];
    
    [RACObserve(self, total) subscribeNext:^(NSNumber *total) {
        self.stepEndLabel.text = JXStrWithFmt(@"第%ld题", (long)total.integerValue);
    }];
    
    [RACObserve(self.finishView, hidden) subscribeNext:^(NSNumber *hidden) {
        if (hidden.boolValue) {
            self.navigationItem.rightBarButtonItem = nil;
        }else {
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem jx_barItemWithImage:JXImageWithName(@"ic_share") size:CGSizeMake(16, 16) target:self action:@selector(share)];
            
            if (self.isFromMine) {
                self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(backItemPressed:), JXColorHex(0x333333));
                [self.navigationItem setHidesBackButton:NO];
            }else {
                self.navigationItem.leftBarButtonItem = nil;
                [self.navigationItem setHidesBackButton:YES];
            }
        }
    }];
    
    [RACObserve(self, step) subscribeNext:^(NSNumber *step) {
        NSInteger index = step.integerValue;
        if (index == 0) {
            if (self.isFromMine) {
                self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(backItemPressed:), JXColorHex(0x333333));
                [self.navigationItem setHidesBackButton:NO];
            }else {
                self.navigationItem.leftBarButtonItem = nil;
                [self.navigationItem setHidesBackButton:YES];
            }
        }else if (index == 1) {
//            self.navigationItem.leftBarButtonItem = nil;
//            [self.navigationItem setHidesBackButton:YES];
            self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(backItemPressed:), JXColorHex(0x333333));
            [self.navigationItem setHidesBackButton:NO];
//        }
//        else if (index == (self.qsts.count - 0)) {
//            if (self.isFromMine) {
//                self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(backItemPressed:), JXColorHex(0x333333));
//                [self.navigationItem setHidesBackButton:NO];
//            }else {
//                self.navigationItem.leftBarButtonItem = nil;
//                [self.navigationItem setHidesBackButton:YES];
//            }
        }else {
            self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(backItemPressed:), JXColorHex(0x333333));
            [self.navigationItem setHidesBackButton:NO];
        }
        
        if (index > 0) {
            Mytest *t = self.qsts[index - 1];
            if (t.type != 0 && (t.type != self.sex)) {
                if (self.isBack) {
                    self.step--;
                }else {
                    self.step++;
                }
            }else {
                self.stepStartLabel.text = JXStrWithFmt(@"第%ld题", (long)step.integerValue);
                self.middlePBzConstraint.constant = (step.integerValue * self.progressStep);
                
                if (!self.onceAnimated) {
                    self.onceAnimated = YES;
                }else {
                    [self.view setNeedsUpdateConstraints];
                    [self.view updateConstraintsIfNeeded];
                    [UIView animateWithDuration:0.3 animations:^{
                        [self.view layoutIfNeeded];
                    } completion:NULL];
                }
                
                // 题目
                if (index <= self.qsts.count && index >= 1) {
                    NSString *str = JXStrWithFmt(@"%ld. %@", (long)index, t.topic);
                    NSMutableAttributedString *ma = [NSMutableAttributedString jx_attributedStringWithString:str color:JXColorHex(0x333333) font:JXFont(15)];
                    [ma jx_addLineSpacing:4.0 alignment:NSTextAlignmentLeft];
                    self.qstLabel.attributedText = ma;
                    
                    for (UIView *v in self.qstView.subviews) {
                        if ([v isKindOfClass:[UIButton class]]) {
                            [v removeFromSuperview];
                        }
                    }
                    
                    // ABCDEFGHIJKLMNOPQRSTUVWXYZ
                    NSArray *chars = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N"];
                    UIButton *preBtn = nil;
                    for (NSInteger i = 0; i < t.answerArr.count; ++i) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.titleLabel.font = JXFont(15);
                        btn.titleLabel.numberOfLines = 5;
                        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        [btn setTitleColor:JXColorHex(0x333333) forState:UIControlStateNormal];
                        [btn setBackgroundImage:JXImageWithColor(JXColorHex(0xB2C9BB)) forState:UIControlStateSelected];
                        [btn setBackgroundImage:JXImageWithColor(JXColorHex(0xB2C9BB)) forState:UIControlStateHighlighted];
                        [btn addTarget:self action:@selector(awsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                        
                        MytestAnswer *a = t.answerArr[i];
                        NSString *str = JXStrWithFmt(@" %@. %@", chars[i], a.reply);
                        [btn setTitle:str forState:UIControlStateNormal];
                        btn.jxTag = RACTuplePack(t, a);
                        
                        btn.selected = a.selected;
                        
                        [self.qstView addSubview:btn];
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.leading.equalTo(self.qstLabel.mas_leading);
                            make.trailing.equalTo(self.qstLabel.mas_trailing);
                            if (preBtn) {
                                make.top.equalTo(preBtn.mas_bottom).offset(12);
                            }else {
                                make.top.equalTo(self.qstLabel.mas_bottom).offset(12);
                            }
                            make.height.equalTo(@(JXAdaptScreen(30)));
                        }];
                        
                        preBtn = btn;
                    }
                }
            }
        }
    }];
}

//- (id)fetchLocalData {
//    return [TMInstance objectForKey:kTMTestQAs];
//}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
//    return [[HRInstance listItemBank] map:^id _Nullable(NSArray *tests) {
//        if (0 != tests.count) {
//            [TMInstance setObject:tests forKey:@"MyTestItems"];
//        }
//        return tests;
//    }];

//    if (gUser.isLogined) {
//        return [RACSignal combineLatest:@[[HRInstance listItemBank], [HRInstance listOldEvaluate]]];
//    }

    return [HRInstance listItemBank];
}

//#pragma mark table
//- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
//    return [JXCell height];
//}
//
//- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(id)object {
//    return [self.tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
//}
//
//- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
//    JXCell *myCell = (JXCell *)cell;
//    myCell.data = object;
//}

#pragma mark empty
#pragma mark - Accessor
- (RACCommand *)saveCommand {
    if (!_saveCommand) {
        _saveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *t) {
            return [HRInstance saveEvaluate:t.first fractionJson:t.second];
        }];
        [_saveCommand.executing subscribe:self.executing];
        [_saveCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_saveCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            @strongify(self)
            [self.listCommand execute:nil];
        }];
    }
    return _saveCommand;
}

- (RACCommand *)listCommand {
    if (!_listCommand) {
        _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance listOldEvaluate];
        }];
       // [_listCommand.executing subscribe:self.executing];
        [_listCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_listCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            @strongify(self)
            JXHUDHide();
            
            if (items.count != 0) {
                [TMInstance setObject:items forKey:kTMTestList];
            }else {
                [TMInstance setObject:@[] forKey:kTMTestList];
            }
            
            self.records = items;
            
            if (self.recordView) {
                self.recordView.records = items;
                [self.recordView.tableView reloadData];
            }
            
//            if ([JXDevice sharedInstance].isSmall) {
//                self.contentContraint.constant = 100;
//            }
//            self.tableBgView.hidden = NO;
//            self.tableBgView.alpha = 0.0;
            
            
            if (self.records.count != 0) {
                MytestResult *r = self.records[0];
                self.mytz = r.physicalName;
                self.mytm = r.createTime;
                [self configResult];
            }else {
                NSString *time = [[[NSDate alloc] init] jx_stringWithFormat:kJXFormatDateStyle1];
                self.mytm = time;
                [self configResult];
            }
            
            for (Mytest *t in self.qsts) {
                for (MytestAnswer *a in t.answerArr) {
                    a.selected = NO;
                }
            }
            [self.results removeAllObjects];
            [self.resultCounts removeAllObjects];
            
            
            self.startView.hidden = NO;
            self.middleView.hidden = NO;
            self.resultView.hidden = NO;
            
            self.finishView.hidden = NO;
            self.finishView.alpha = 0.0;
            [UIView animateWithDuration:0.3 animations:^{
                self.finishView.alpha = 1.0;
            } completion:^(BOOL finished) {
            }];
        }];
    }
    return _listCommand;
}



#pragma mark - Private
- (void)share {
    if (![WXApi isWXAppInstalled]) {
        [JXDialog showPopup:@"未安装微信，无法分享"];
        return;
    }
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        NSString *title = @"你了解自己吗？他更懂你";
        NSString *desc = @"你知道你是什么体质吗? 测测更健康";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:JXImageWithName(@"my_appicon")];
        shareObject.webpageUrl = @"http://dl.appvworks.com/doctor/user_app/index.html";
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        }];
    }];
}
#pragma mark - Public
- (void)calResult {
    for (NSInteger i = 1; i < self.qsts.count; ++i) {
        Mytest *t = self.qsts[i];
        if (t.physical.length == 0) {
            continue;
        }
        
        NSArray *keys = self.results.allKeys;
        BOOL has = NO;
        for (NSString *k in keys) {
            if ([k isEqualToString:t.physical]) {
                has = YES;
                break;
            }
        }
        MytestAnswer *a = nil;
        for (MytestAnswer *answer in t.answerArr) {
            if (answer.selected) {
                a = answer;
                break;
            }
        }
        if (!a) {
            continue;
        }
        
        NSNumber *number = [self.results objectForKey:t.physical];
        NSInteger score = number.integerValue + a.answer;
        [self.results setObject:@(score) forKey:t.physical];
        
        NSNumber *c1 = [self.resultCounts objectForKey:t.physical];
        NSInteger c2 = c1.integerValue + 1;
        [self.resultCounts setObject:@(c2) forKey:t.physical];
    }
    
    NSArray *keys = self.results.allKeys;
    for (NSString *k in keys) {
        NSInteger score = [[self.results objectForKey:k] integerValue];
        NSInteger count = [[self.resultCounts objectForKey:k] integerValue];
        // [（原始分-条目数）/（条目数×4）] ×100
        CGFloat s = (score - count) / (count * 4.0) * 100.0;
        [self.results setObject:@(s) forKey:k];
    }
    
    self.mytz = nil;
    for (NSString *k in keys) {
        NSInteger score = [[self.results objectForKey:k] integerValue];
        if (![k isEqualToString:@"平和质"]) {
            if (score >= 30) {
                self.mytz = k;
                break;
            }
        }
    }
    
    if (self.mytz.length == 0) {
        self.mytz = @"平和质";
    }
    
    NSString *time = [[[NSDate alloc] init] jx_stringWithFormat:kJXFormatDateStyle1];
    self.mytm = time;
    
    [self configResult];
}

- (RACTuple *)getResult {
    if ([self.mytz isEqualToString:@"平和质"]) {
        return RACTuplePack(JXImageWithName(@"img_testResult01"),
                            @"平和质，是健康派的代表，精力充沛，性格开朗，心态平和是你的标签。",
                            @"平和体质，是幸福的标志，顺应四时变化，根据季节调养，才能保持最好的状态。",
                            @"桂圆红枣枸杞茶",
                            @(1),
                            @(1));
    }else if ([self.mytz isEqualToString:@"特禀质"]) {
        return RACTuplePack(JXImageWithName(@"img_testResult02"),
                            @"特禀质，是敏感派的代表，容易过敏，经常喷嚏流涕，鼻塞，皮肤易有抓痕，荨麻疹是你的标签。",
                            @"特禀质是敏感的标志，远离过敏源，远离人群，更要增强免疫力，强壮元气。",
                            @"参杞元气茶",
                            @(8),
                            @(1));
    }else if ([self.mytz isEqualToString:@"气虚质"]) {
        return RACTuplePack(JXImageWithName(@"img_testResult03"),
                            @"气虚质，是气短派的代表，容易疲倦，少气懒言，声音低弱，喜欢安静，容易感冒是你的标签。",
                            @"气虚质是虚弱的标志，需要巩固正气，膳食合理，更要补充元气。",
                            @"黄芪元气茶",
                            @(4),
                            @(1));
    }else if ([self.mytz isEqualToString:@"阳虚质"]) {
        return RACTuplePack(JXImageWithName(@"img_testResult04"),
                            @"阳虚质是怕冷派的代表，手脚发凉，不耐寒冷，容易腹泻小便清长是你的标签。",
                            @"阳虚质是缺火的标志，怕冷，穿得多，喜欢吃热食，需要尽量保暖，禁食生冷蔬菜水果，更要温补阳气。",
                            @"五味温补茶",
                            @(2),
                            @(1));
    }else if ([self.mytz isEqualToString:@"痰湿质"]) {
        return RACTuplePack(JXImageWithName(@"img_testResult05"),
                            @"痰湿质是痰派的代表，肥胖肚子大，满面油光，眼皮肿是你的标签。",
                            @"痰湿质是多痰的标志，容易肥胖，需要禁食脂肪甜食多运动，更要清脂减肥。",
                            @"山楂荷叶减肥茶",
                            @(5),
                            @(1));
    }else if ([self.mytz isEqualToString:@"湿热质"]) {
        return RACTuplePack(JXImageWithName(@"img_testResult06"),
                            @"湿热质是长痘派的代表，满面油腻，易生痤疮，口苦口臭，大便粘腻是你的标签。",
                            @"湿热质是烦恼的标志，需要清火祛痘，更要清痰湿，助脾胃运化消食。",
                            @"金茯消食饮",
                            @(6),
                            @(1));
    }else if ([self.mytz isEqualToString:@"血瘀质"]) {
        return RACTuplePack(JXImageWithName(@"img_testResult07"),
                            @"血瘀质是长斑派的代表，面色晦暗，极易长斑，皮肤易青紫、月经痛，容易忘事是你的标签。",
                            @"血瘀质是疼痛的标志，需要活血化瘀，行气止痛，更要美容养颜，清面消斑。",
                            @"玫瑰四物茶",
                            @(7),
                            @(1));
    }else if ([self.mytz isEqualToString:@"气郁质"]) {
        return RACTuplePack(JXImageWithName(@"img_testResult08"),
                            @"气郁质是郁闷派的代表，情绪低落，精神紧张，多愁善感，唉声叹气是你的标签。",
                            @"气郁质是郁闷的标志，需要调节心情，开阔思想。乐观处世，更要行气解郁，安神宁心。",
                            @"玫瑰解郁茶",
                            @(9),
                            @(1));
    }else if ([self.mytz isEqualToString:@"阴虚质"]) {
        return RACTuplePack(JXImageWithName(@"img_testResult09"),
                            @"阴虚质是缺水派的代表，手脚心热，口干舌燥，两颧潮红，大便干燥是你的标签。",
                            @"阴虚质是燥热的标志，需要降火清热，更需要滋补津液，滋润全身。",
                            @"玉竹生津饮",
                            @(2),
                            @(1));
    }
    
    return nil;
}

- (void)configResult {
    self.mytuple = [self getResult];
    if (!self.mytuple) {
        JXHUDInfo(@"计算错误", YES);
        return;
    }
    
    self.rLogoImageView.image = self.mytuple.first;
    self.rWhatLabel.text = self.mytuple.second;
    self.rTodoLabel.text = self.mytuple.third;
    self.rGoodsLabel.text = self.mytuple.fourth;
    
    self.rWhatTitleLabel.text = JXStrWithFmt(@"什么是%@?", self.mytz);
    // self.rBuyButton.tag = [self.mytuple.fifth integerValue];
    
    NSString *time = [self.mytm substringToIndex:10];
    self.timeOrMyLabel.text = JXStrWithFmt(@"测试时间 %@", time);
}

#pragma mark - Action
- (IBAction)startYulanButton:(id)sender {
    MytestIntro *intro = [[[NSBundle mainBundle] loadNibNamed:@"MytestIntro" owner:nil options:nil] firstObject];
    KLCPopup *popup = [KLCPopup popupWithContentView:intro showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [popup showWithLayout:KLCPopupLayoutCenter];
}

- (IBAction)startKaishiButton:(id)sender {
    for (Mytest *t in self.qsts) {
        for (MytestAnswer *a in t.answerArr) {
            a.selected = NO;
        }
    }
    [self.results removeAllObjects];
    [self.resultCounts removeAllObjects];
    
    self.step = 1;
    
    self.middleView.alpha = 0.0;
    self.middleView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.middleView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)awsButtonPressed:(UIButton *)btn {
    self.isBack = NO;
    
    if (self.step >= self.total) {
                    if (self.isFromMine) {
                        self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(backItemPressed:), JXColorHex(0x333333));
                        [self.navigationItem setHidesBackButton:NO];
                    }else {
                        self.navigationItem.leftBarButtonItem = nil;
                        [self.navigationItem setHidesBackButton:YES];
                    }
        
        [self calResult];
        self.resultView.alpha = 0.0;
        self.resultView.hidden = NO;
        self.timeOrMyLabel.text = @"我的体质是";
        self.finishView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.resultView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    
    btn.selected = YES;
    
    Mytest *t = [(RACTuple *)btn.jxTag first];
    for (MytestAnswer *a in t.answerArr) {
        a.selected = NO;
    }
    MytestAnswer *a = [(RACTuple *)btn.jxTag second];
    a.selected = YES;

    self.step++;
}

- (void)backItemPressed:(id)sender {
    if (self.middleView.hidden == NO && self.resultView.hidden == YES) {
        self.isBack = YES;
        if (self.step == 1 || (self.step >= self.total)) {
            if (self.step == 1) {
                self.step = 0;
                
                [self showIfNeedWithLogin];
//                self.startView.alpha = 0.0;
//                self.startView.hidden = NO;
//                self.middleView.hidden = YES;
//                [UIView animateWithDuration:0.5 animations:^{
//                    self.startView.alpha = 1.0;
//                } completion:^(BOOL finished) {
//                    for (Mytest *t in self.qsts) {
//                        for (MytestAnswer *a in t.answerArr) {
//                            a.selected = NO;
//                        }
//                    }
//                    [self.results removeAllObjects];
//                    [self.resultCounts removeAllObjects];
//                }];
            }
            return;
        }
        self.step--;
        return;
    }
    
    if (self.isFromMine) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    if (self.resultView.hidden == NO) {
//        if (self.isFromMine) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        return;
//    }
}

- (IBAction)resultAgainButtonPressed:(id)sender {
    for (Mytest *t in self.qsts) {
        for (MytestAnswer *a in t.answerArr) {
            a.selected = NO;
        }
    }
    [self.results removeAllObjects];
    [self.resultCounts removeAllObjects];
    
    self.step = 1;
    
//    if ([JXDevice sharedInstance].isSmall) {
//        self.contentContraint.constant = 0;
//    }
    self.middleView.hidden = NO;
    self.resultView.hidden = NO;
    self.resultView.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.resultView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.resultView.hidden = YES;
        self.resultView.alpha = 1.0;
        
        //self.tableBgView.hidden = YES;
        self.finishView.hidden = YES;
    }];
}

- (IBAction)resultSaveButtonPressed:(id)sender {
    [gUser checkLoginWithFinish:^(BOOL isRelogin) {
        NSString *physiqueName = self.mytz;
        NSString *fractionJson = [self.results mj_JSONString];
        
        [self.saveCommand execute:RACTuplePack(physiqueName, fractionJson)];
    } error:nil];
}

- (IBAction)rBuyButtonPressed:(UIButton *)btn {
    NSInteger gid = [self.mytuple.fifth integerValue];
    //NSInteger sid = [self.mytuple.last integerValue];
    NSString *link = JXStrWithFmt(kGoodsDetailLink2, gid);
    
    AWWebViewController *vc = [[AWWebViewController alloc] initWithURL:JXURLWithStr(link) title:@"商品详情"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navItemColor = JXColorHex(0x333333);
    vc.statusBarStyle = JXStatusBarStyleDefault;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)resultAgainButton2Pressed:(id)sender {
    [self resultAgainButtonPressed:nil];
}

- (IBAction)recordButtonPressed:(id)sender {
    if (!self.recordView) {
        self.recordView = [[[NSBundle mainBundle] loadNibNamed:@"MytestRecordView" owner:nil options:nil] firstObject];
    }
    self.recordView.records = self.records;
    // [self.recordView.tableView reloadData];
    
    KLCPopup *popup = [KLCPopup popupWithContentView:self.recordView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [popup showWithLayout:KLCPopupLayoutCenter];
    
    @weakify(self)
    self.recordView.closeBlock = ^(MytestResult *r) {
        @strongify(self)
        self.mytz = r.physicalName;
        self.mytm = r.createTime;
        [self configResult];
        [popup dismiss:YES];
    };
}

#pragma mark - Notification
#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JXAdaptScreen(32.0f);
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (!self.isFinished) {
//        return 0;
//    }
    return JXAdaptScreen(36.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
//    header.contentView.backgroundColor = [UIColor whiteColor];
//    header.textLabel.text = @"历史测试记录";
//    header.textLabel.font = JXFont(13);
//    header.textLabel.textColor = JXColorHex(0x3D8158);
    
    UIView *bgView = [[[NSBundle mainBundle] loadNibNamed:@"MytestRecordTitleView" owner:nil options:nil] firstObject];
    [header addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header);
    }];
    
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MytestResult *r = self.records[indexPath.row];
    self.mytz = r.physicalName;
    [self configResult];
}

#pragma mark - Class

@end










