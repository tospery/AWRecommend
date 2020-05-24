//
//  LocateNearbyViewController.m
//  TIMChat
//
//  Created by 杨建祥 on 16/11/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "LocateNearbyViewController.h"

#define LocateNearbyCellIdentifier          (@"LocateNearbyCellIdentifier")

@interface LocateNearbyViewController ()
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) AMapPOIAroundSearchRequest *request;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation LocateNearbyViewController
#pragma mark - Override methods
//- (instancetype)init {
//    if (self = [super init]) {
//        self.shouldRequestRemoteDataOnViewDidLoad = YES;
//        self.shouldPullToRefresh = YES;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVar];
    [self setupData];
    [self setupView];
    [self setupSignal];
    [self setupNet];
}

-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)bindViewModel {
    [super bindViewModel];
    
//    RAC(self, dataSource) = [[[self.requestRemoteDataCommand.executionSignals.switchToLatest startWith:self.fetchLocalData] map:^id(NSArray *items) {
//        return JXArrValue(items, [NSArray new]);
//    }] map:^id(NSArray *items) {
//        return @[JXArrValue(items, [NSArray new])];
//    }];
}

- (void)dealloc {
    if (self.locationManager.delegate) {
        [self.locationManager stopUpdatingLocation];
        [self.locationManager setDelegate:nil];
    }

    self.completionBlock = nil;
}

#pragma mark - Private methods
#pragma mark setup

- (void)setupVar {
    @weakify(self)
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self)
        [self.locationManager stopUpdatingLocation];
        [self.locationManager setDelegate:nil];
        
        if (error) {
            JXHUDError(error.localizedDescription, YES);
        }else {
            self.location = location;
            
            self.search = [[AMapSearchAPI alloc] init];
            self.search.delegate = self;
            
            [self searchPoiByCenterCoordinate];
        }
    };
}

- (void)setupData {
}

- (void)setupView {
    self.navigationItem.title = @"附件地址";
    
//    UINib *cellNib = [UINib nibWithNibName:@"DhzyDaibanCell" bundle:nil];
//    [self.tableView registerNib:cellNib forCellReuseIdentifier:[DhzyDaibanCell identifier]];
//    self.tableView.tableFooterView = [UIView new];
    
    //[self.tableView registerClass:[JXCellValue1 class] forCellReuseIdentifier:[JXCellValue1 identifier]];
    self.tableView.tableFooterView = [UIView new];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:10];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:10];
    
    JXHUDProcessing(nil);
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

- (void)setupSignal {
}

- (void)setupNet {
}

#pragma mark fetch
#pragma mark request
#pragma mark assist
- (void)searchPoiByCenterCoordinate {
    self.request = [[AMapPOIAroundSearchRequest alloc] init];
    
    self.request.location            = [AMapGeoPoint locationWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
    //request.keywords            = @"电影院";
    /* 按照距离排序. */
    self.request.sortrule            = 0;
    self.request.requireExtension    = YES;
    //request.radius = 50000;
    
    [self.search AMapPOIAroundSearch:self.request];
}


//#pragma mark - Table
//- (id)fetchLocalData {
//    return nil;
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//    return [HRInstance requestDhzyDaibanListWithPage:1];
//}
//
//- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath object:(id)object {
//    DhzyDaibanCell *myCell = (DhzyDaibanCell *)cell;
//    myCell.data = object;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [DhzyDaibanCell height];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
//    return [tableView dequeueReusableCellWithIdentifier:[DhzyDaibanCell identifier] forIndexPath:indexPath];
//}

#pragma mark - Accessor methods
#pragma mark - Action methods
#pragma mark - Notification methods

#pragma mark - Delegate methods
#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    JXHUDError(error.localizedDescription, YES);
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        JXHUDError(@"获取失败", YES);
        return;
    }
    
    self.items = response.pois;
    [self.tableView reloadData];
    
    JXHUDHide();
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocateNearbyCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:LocateNearbyCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = JXColorHex(0x333333);
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.textColor = JXColorHex(0x999999);
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.imageView.image = JXAdaptImage(JXImageWithName(@"ic_location_gray"));
    }
    
    AMapPOI *poi = self.items[indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMapPOI *poi = self.items[indexPath.row];
    if (self.resultBlock) {
        self.resultBlock(poi);
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNotifyPOIDidSelect object:poi];
    
    NSArray *arr = self.navigationController.viewControllers;
    NSMutableArray *mrr = [NSMutableArray arrayWithArray:arr];
    [mrr removeObjectAtIndex:(arr.count -2)];
    self.navigationController.viewControllers = mrr;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - Public methods
#pragma mark - Class methods


@end
