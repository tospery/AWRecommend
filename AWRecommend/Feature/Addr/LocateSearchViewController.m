//
//  LocateSearchViewController.m
//  TIMChat
//
//  Created by 杨建祥 on 16/11/28.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "LocateSearchViewController.h"
#import "LocateNearbyViewController.h"

#define LocateSearchCellIdentifier      (@"LocateSearchCellIdentifier")

@interface LocateSearchViewController ()
@property (nonatomic, strong) JXLocationManager *lManager;

@property (nonatomic, weak) IBOutlet UIView *searchBgView;
@property (nonatomic, weak) IBOutlet UIView *nearbyBgView;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet JXButton *cityButton;

@end

@implementation LocateSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"搜索地址";
    
    self.tableView.tableFooterView = [UIView new];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    
    self.cityButton.style = JXButtonStyleRight;
    self.cityButton.distance = 3.0f;
    
    NSString *showName = self.cityName;
    if (showName.length > 4) {
        showName = [showName substringToIndex:4];
        showName = JXStrWithFmt(@"%@...", showName);
    }
    [self.cityButton setTitle:showName forState:UIControlStateNormal];
    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
//     
//     setTitleTextAttributes:
//     
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      
//      [UIColor whiteColor],
//      
//      UITextAttributeTextColor,
//      
//      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
//      
//      UITextAttributeTextShadowOffset,nil]
//     
//     forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[UIBarButtonItem jx_appearanceWithParam:@{kJXKeyTitleColor: SMInstance.mainColor, kJXKeyTitleColorDisabled: SMInstance.textLightColor, kJXKeyTitleFont: [UIFont systemFontOfSize:16.0f]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[UIBarButtonItem jx_appearanceWithParam:@{kJXKeyTitleColor: SMInstance.textColor, kJXKeyTitleColorDisabled: SMInstance.textLightColor, kJXKeyTitleFont: [UIFont systemFontOfSize:16.0f]}];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.searchBgView jx_borderWithColor:JXColorHex(0xCDCDCD) width:0.4 radius:4.0];
    [self.nearbyBgView jx_borderWithColor:JXColorHex(0xCDCDCD) width:0.4 radius:0.0];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (IBAction)nearbyButtonPressed:(id)sender {
//    if (!self.lManager) {
//        self.lManager = [[JXLocationManager alloc] init];
//        self.lManager.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
//        
//        JXHUDProcessing(nil);
//        [self.lManager startLocatingWithSuccess:^(CLLocation *location) {
//            JXHUDHide();
//            LocateNearbyViewController *vc = [[LocateNearbyViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        } failure:^(NSError *error) {
//            JXHUDError(error.localizedDescription, YES);
//        }];
//    }else {
        LocateNearbyViewController *vc = [[LocateNearbyViewController alloc] init];
    vc.cityName = self.cityName;
    vc.resultBlock = self.resultBlock;
        [self.navigationController pushViewController:vc animated:YES];
    //}
}

- (IBAction)cityButtonPressed:(id)sender {
    AddrCityViewController *vc = [[AddrCityViewController alloc] init];
    vc.selectBlock = ^(NSString *city) {
        JXLogDebug(@"所选城市：%@", city);
        self.cityName = city;
        
        NSString *showName = self.cityName;
        if (showName.length > 4) {
            showName = [showName substringToIndex:4];
            showName = JXStrWithFmt(@"%@...", showName);
        }
        [self.cityButton setTitle:showName forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    if(self.searchBar.text.length == 0) {
        self.items = nil;
        [self.tableView reloadData];
        return;
    }
    
    [self searchPoiByKeyword:self.searchBar.text];
}

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
    
    // int a = 0;
//    [self.mapView removeAnnotations:self.mapView.annotations];
//    
//    if (response.pois.count == 0) {
//        return;
//    }
//    
//    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
//    
//    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
//        
//        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
//        
//    }];
//    
//    /* 将结果以annotation的形式加载到地图上. */
//    [self.mapView addAnnotations:poiAnnotations];
//    
//    /* 如果只有一个结果，设置其为中心点. */
//    if (poiAnnotations.count == 1)
//    {
//        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
//    }
//    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
//    else
//    {
//        [self.mapView showAnnotations:poiAnnotations animated:NO];
    // }
}

/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword:(NSString *)keyword {
    JXHUDProcessing(nil);
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    //    request.keywords            = @"北京大学";
    //    request.city                = @"北京";
    //    request.types               = @"高等院校";
    //    request.requireExtension    = YES;
    //
    //    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    //    request.cityLimit           = YES;
    //request.city = @"成都";
    request.city = self.cityName;
    request.requireExtension    = YES;
    request.cityLimit           = YES;
    
    request.requireSubPOIs      = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocateSearchCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:LocateSearchCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = JXColorHex(0x333333); // JXInstance.cellTitleColor;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.textColor = JXColorHex(0x999999); // JXInstance.cellDetailColor;
        
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
@end
