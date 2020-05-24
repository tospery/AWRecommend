//
//  AddrAddViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/9/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "AddrAddViewController.h"
#import "JXAMapLocationManager.h"
#import "LocateSearchViewController.h"

@interface AddrAddViewController ()
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UITextField *cityField;
@property (nonatomic, weak) IBOutlet UITextField *locationField;
@property (nonatomic, weak) IBOutlet UITextField *detailField;

@property (nonatomic, weak) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) AMapPOI *poi;
//@property (nonatomic, strong) JXAMapLocationManager *locationManager;
@property (nonatomic, strong) RACCommand *addCommand;
@property (nonatomic, strong) RACCommand *updateCommand;

@end

@implementation AddrAddViewController
#pragma mark - Override
#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        //self.shouldRequestRemoteDataOnViewDidLoad = YES;
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

#pragma mark setup
- (void)setupVar {
    WebInteractionData *d = (WebInteractionData *)self.param;
    if (d) {
        self.nameField.text = d.trueName;
        self.phoneField.text = d.mobPhone;
        self.cityField.text = d.city;
        self.locationField.text = d.address;
        self.detailField.text = d.houseNumber;
    }else {
        self.phoneField.text = gUser.mobile;
    }
}

- (void)setupView {
    self.navigationItem.title = @"新增收货地址";
    if (self.param) {
        self.navigationItem.title = @"修改收货地址";
    }
    
    //    UINib *nib = [UINib nibWithNibName:@"JXCell" bundle:nil];
    //    [self.tableView registerNib:nib forCellReuseIdentifier:[JXCell identifier]];
    //    self.tableView.tableFooterView = [UIView new];
    
    [SMInstance configButtonStyle1:self.submitButton fontSize:18.0 borderRadius:20.0];
}

- (void)setupNet {
    if (self.param == nil) {
        JXAMapLocationManager *mananger = [[JXAMapLocationManager alloc] init];
        //    self.cityField.text = @"正在定位";
        [JXDialog showHUD:nil];
        [[mananger locateSignal] subscribeNext:^(RACTuple *t) {
            //        if ([self.cityField.text isEqualToString:@"正在定位"]) {
            //            AMapLocationReGeocode *geo = t.second;
            //            self.cityField.text = geo.city;
            //            if (0 == self.cityField.text) {
            //                self.cityField.text = @"定位失败，请手动选择";
            //            }
            //        }
            [JXDialog hideHUD];
            AMapLocationReGeocode *geo = t.second;
            self.cityField.text = geo.city;
            if (0 == self.cityField.text) {
                self.cityField.text = @"成都市";
            }
        } error:^(NSError * _Nullable error) {
            //        if (0 == self.cityField.text) {
            //            self.cityField.text = @"定位失败，请手动选择";
            //        }
            [JXDialog hideHUD];
            self.cityField.text = @"成都市";
        }];
    }
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    //    RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    //    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    //    RAC(self, dataSource) = [[[fetchLocalDataSignal merge:requestRemoteDataSignal] deliverOnMainThread] map:^id _Nullable(id result) {
    //        return JXArrTable(result);
    //    }];
}

//- (id)fetchLocalData {
//    return nil;
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
//    return [HRInstance requestDhzyDaibanListWithPage:1];
//}

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
- (RACCommand *)addCommand {
    if (!_addCommand) {
        _addCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance createByAccountAddress:input];
        }];
        [_addCommand.executing subscribe:self.executing];
        [_addCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_addCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            @strongify(self)
            [JXDialog hideHUD];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _addCommand;
}

- (RACCommand *)updateCommand {
    if (!_updateCommand) {
        _updateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [HRInstance updateByAccountAddress:input];
        }];
        [_updateCommand.executing subscribe:self.executing];
        [_updateCommand.errors subscribe:self.errors];
        
        @weakify(self)
        [_updateCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *items) {
            @strongify(self)
            [JXDialog hideHUD];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _updateCommand;
}


#pragma mark - Private
- (NSString *)verifyInput {
    if (0 == self.nameField.text.length) {
        return @"请输入收货人姓名";
    }
    
    if (0 == self.phoneField.text.length) {
        return @"请输入联系电话";
    }
    
    if (0 == self.locationField.text.length) {
        return @"请选择定位地址";
    }
    
    return nil;
}

#pragma mark - Public

#pragma mark - Action
- (void)entrySearch {
    LocateSearchViewController *vc = [[LocateSearchViewController alloc] init];
    vc.cityName = self.cityField.text;
    vc.resultBlock = ^(AMapPOI *poi) {
        self.poi = poi;
        self.cityField.text = self.poi.city;
        self.locationField.text = self.poi.address;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cityButtonPressed:(id)sender {
    [self entrySearch];
}

- (IBAction)locationButtonPressed:(id)sender {
    [self entrySearch];
}

- (IBAction)submitButtonPressed:(id)sender {
    NSString *result = [self verifyInput];
    if (0 != result.length) {
        [JXDialog showPopup:result];
        return;
    }
    
    if (self.param == nil) {
        NSString *addr = JXStrWithFmt(@"%f,%f", self.poi.location.latitude, self.poi.location.longitude);
        NSDictionary *param = @{    @"address":JXStrWithDft(self.poi.address, @""),
                                    @"area":JXStrWithDft(self.poi.district, @""),
                                    @"areaId":JXStrWithDft(self.poi.adcode, @""),
                                    @"city":JXStrWithDft(self.poi.city, @""),
                                    @"cityId":JXStrWithDft(self.poi.citycode, @""),
                                    @"gpsAddress":JXStrWithDft(addr, @""),
                                    @"houseNumber":JXStrWithDft(self.detailField.text, @""),
                                    @"mobPhone":JXStrWithDft(self.phoneField.text, @""),
                                    @"province":JXStrWithDft(self.poi.province, @""),
                                    @"provinceId":JXStrWithDft(self.poi.pcode, @""),
                                    @"trueName":JXStrWithDft(self.nameField.text, @"")};
        [self.addCommand execute:param];
    }else {
        WebInteractionData *d = (WebInteractionData *)self.param;
        
        NSString *area = d.area;
        NSString *areaId = d.areaId;
        NSString *city = d.city;
        NSString *cityId = d.cityId;
        NSString *gpsAddress = d.gpsAddress;
        NSString *province = d.province;
        NSString *provinceId = d.provinceId;
        if (self.poi) {
            area = self.poi.district;
            areaId = self.poi.adcode;
            city = self.poi.city;
            cityId = self.poi.citycode;
            gpsAddress = JXStrWithFmt(@"%f,%f", self.poi.location.latitude, self.poi.location.longitude);
            province = self.poi.province;
            provinceId = self.poi.pcode;
        }
        
        NSDictionary *param = @{@"addressId":JXStrWithDft(d.addressId, @""),
                                @"address":JXStrWithDft(self.locationField.text, @""),
                                @"area":JXStrWithDft(area, @""),
                                    @"areaId":JXStrWithDft(areaId, @""),
                                    @"city":JXStrWithDft(city, @""),
                                    @"cityId":JXStrWithDft(cityId, @""),
                                    @"gpsAddress":JXStrWithDft(gpsAddress, @""),
                                    @"houseNumber":JXStrWithDft(self.detailField.text, @""),
                                    @"mobPhone":JXStrWithDft(self.phoneField.text, @""),
                                    @"province":JXStrWithDft(province, @""),
                                    @"provinceId":JXStrWithDft(provinceId, @""),
                                    @"trueName":JXStrWithDft(self.nameField.text, @"")};
        [self.updateCommand execute:param];
    }
}

#pragma mark - Notification
#pragma mark - Delegate
#pragma mark - Class

@end









