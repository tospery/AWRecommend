//
//  AddrCityViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/9/20.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "AddrCityViewController.h"
#import "JXAMapLocationManager.h"

@interface AddrCityViewController () 
@property (nonatomic, strong) RACTuple *tp;
@property (nonatomic, strong) AddrCollect *ac;

@property (nonatomic, strong) NSDictionary *toSearchDict;
@property (nonatomic, strong) NSArray *toSearchItems;
@property (nonatomic, strong) NSDictionary *cities;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableArray *results;

@property (nonatomic, strong) JXAMapLocationManager *locationManager;
// @property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
// @property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UITableView *resultTableView;

@end

@implementation AddrCityViewController
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.searchView jx_borderWithColor:[UIColor clearColor] width:0.0 radius:4.0];
}

#pragma mark setup
- (void)setupVar {
    self.results = [NSMutableArray arrayWithCapacity:20];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"all_citys" ofType:@"json"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.ac = [AddrCollect mj_objectWithKeyValues:str];
    
//    UISearchController *search = [[UISearchController alloc] initWithSearchResultsController:nil];
//    // 设置结果更新代理
//    search.searchResultsUpdater = self;
//    // 因为在当前控制器展示结果, 所以不需要这个透明视图
//    search.dimsBackgroundDuringPresentation = NO;
//    self.searchController = search;
//    // 将searchBar赋值给tableView的tableHeaderView
//    self.tableView.tableHeaderView = search.searchBar;
}

- (void)setupView {
    self.navigationItem.title = @"选择城市";
    
    [self.resultTableView registerClass:[JXCell class] forCellReuseIdentifier:[JXCell identifier]];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionIndexColor = JXColorHex(0x333333);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tag = 1;
}

- (void)setupNet {
    
}

#pragma mark scroll
- (void)bindViewModel {
    [super bindViewModel];
    
    // RACSignal *fetchLocalDataSignal = [RACSignal return:[self fetchLocalData]];
    RACSignal *requestRemoteDataSignal = self.requestRemoteDataCommand.executionSignals.switchToLatest;
    RAC(self, dataSource) = [[requestRemoteDataSignal deliverOnMainThread] map:^id _Nullable(id result) {
        self.tp = result;
        
        [self genDataWithCity:self.tp.second];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.ac.mj_JSONObject];
//        id obj = [dict objectForKey:@"Hot"];
//        [dict removeObjectForKey:@"Hot"];
//        self.toSearchDict = [NSDictionary dictionaryWithDictionary:dict];
//        
//        [dict setObject:obj forKey:@"热门"];
//        
//        if (self.tp.second) {
//            [dict setObject:@[self.tp.second] forKey:@"定位"];
//        }else {
//            [dict setObject:@[@"定位失败"] forKey:@"定位"];
//        }
//        
//        self.cities = dict;
//        
//        NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.cities.allKeys sortedArrayUsingSelector:@selector(compare:)]];
//        [arr removeObject:@"热门"];
//        [arr removeObject:@"定位"];
//        [arr insertObject:@"热门" atIndex:0];
//        [arr insertObject:@"定位" atIndex:0];
//        self.keys = arr;
        
        return JXArrTable(self.keys);
    }];
}

- (void)genDataWithCity:(AMapLocationReGeocode *)city {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.ac.mj_JSONObject];
    id obj = [dict objectForKey:@"Hot"];
    [dict removeObjectForKey:@"Hot"];
    self.toSearchDict = [NSDictionary dictionaryWithDictionary:dict];
    
    [dict setObject:obj forKey:@"热门"];
    if (city) {
        [dict setObject:@[city] forKey:@"定位"];
    }else {
        [dict setObject:@[@"定位失败"] forKey:@"定位"];
    }
    
    self.cities = dict;
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.cities.allKeys sortedArrayUsingSelector:@selector(compare:)]];
    [arr removeObject:@"热门"];
    [arr removeObject:@"定位"];
    [arr insertObject:@"热门" atIndex:0];
    [arr insertObject:@"定位" atIndex:0];
    self.keys = arr;
}
//- (id)fetchLocalData {
//    return nil;
//}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSInteger)page {
    if (self.locationManager == nil) {
        self.locationManager = [[JXAMapLocationManager alloc] init];
    }
    return [self.locationManager locateSignal];
}

//- (void)reloadData {
//    [self.scrollView reloadEmptyDataSet];
//    [self.tableView reloadData];
//}

- (BOOL)catchError:(NSError *)error {
    BOOL notFilter = YES;
    BOOL nedUpdate = YES;
    
    switch (self.requestMode) {
        case JXRequestModeLoad:
        case JXRequestModeUpdate: {
            break;
        }
        case JXRequestModeRefresh: {
            [self.scrollView.mj_header endRefreshing];
            [self.tableView.mj_header endRefreshing];
            break;
        }
        case JXRequestModeMore: {
            if (JXErrorCodeDataEmpty == error.code) {
                nedUpdate = NO;
                [self.scrollView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.scrollView.mj_footer endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            break;
        }
        case JXRequestModeHUD: {
            [JXDialog hideHUD];
            break;
        }
        default:
            break;
    }
    
    if (JXErrorCodeLoginExpired == error.code) {
        notFilter = NO;
        
        [gUser checkLoginWithFinish:^(BOOL isRelogin) {
            if (isRelogin) {
                [self triggerLoad];
            }
        } error:error];
    }
    
    [self genDataWithCity:nil];
    
    self.requestMode = JXRequestModeNone;
    if (nedUpdate) {
        self.dataSource = JXArrTable(self.keys);
    }
    
    return notFilter;
}

#pragma mark table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
        return [self.keys count];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        NSString *key = self.keys[section];
        NSArray *cities = self.cities[key];
        return [cities count];
    }
    
    return [self.results count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        NSString *title = self.keys[section];
        if ([title isEqualToString:@"热门"]) {
            title = @"热门城市";
        }
        if ([title isEqualToString:@"定位"]) {
            title = @"定位城市";
        }
        return title;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JXCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
//                             SectionsTableIdentifier];
//    if (tableView.tag == 1) {
//        NSString *key = self.keys[indexPath.section];
//        NSArray *nameSection = self.names[key];
//        
//        cell.textLabel.text = nameSection[indexPath.row];
//    } else {
//        cell.textLabel.text = filteredNames[indexPath.row];
//    }
//    return cell;
    
    JXCell *cell = [tableView dequeueReusableCellWithIdentifier:[JXCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView.tag == 1) {
        NSString *key = self.keys[indexPath.section];
        NSArray *cities = self.cities[key];
        id obj = cities[indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            cell.textLabel.text = obj;
        }else if ([obj isKindOfClass:[NSDictionary class]]) {
            cell.textLabel.text = [obj objectForKey:@"name"];
        }else {
            cell.textLabel.text = [(AMapLocationReGeocode *)obj city];
        }

        return cell;
    }
    
    
    cell.textLabel.text = [self.results[indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
        return self.keys;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return JXAdaptScreen(32.0f);
    }
    
    return 0.0f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kJXIdentifierHeaderFooter];
////    header.contentView.backgroundColor = JXColorHex(0xE8E9EA);
////    header.textLabel.textColor = JXColorHex(0x333333);
////    header.textLabel.font = JXFont(15);
//    return header;
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = JXColorHex(0xE8E9EA);
    header.textLabel.textColor = JXColorHex(0x333333);
    header.textLabel.font = JXFont(15);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = nil;
    if (tableView.tag == 1) {
        NSString *key = self.keys[indexPath.section];
        NSArray *cities = self.cities[key];
        id obj = cities[indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            str = obj;
        }else if ([obj isKindOfClass:[NSDictionary class]]) {
            str = [obj objectForKey:@"name"];
        }else {
            str = [(AMapLocationReGeocode *)obj city];
        }
        
        if (self.selectBlock) {
            self.selectBlock(str);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    NSDictionary *obj = self.results[indexPath.row];
    str = [obj objectForKey:@"name"];
    
    if (self.selectBlock) {
        self.selectBlock(str);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

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
#pragma mark - Private
#pragma mark - Public
#pragma mark - Action
- (IBAction)searchInputBegin:(UITextField *)field {
    self.resultTableView.hidden = NO;
    self.tableView.sectionIndexColor = [UIColor clearColor];
}

- (IBAction)searchInputEnd:(UITextField *)field {
    self.resultTableView.hidden = YES;
    self.tableView.sectionIndexColor = JXColorHex(0x333333);
}

- (IBAction)searchInputChange:(UITextField *)field {
    [self.results removeAllObjects];
    
    if (self.toSearchItems.count == 0) {
        NSArray *keys = self.toSearchDict.allKeys;
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:100];
        for (NSString *k in keys) {
            [items addObjectsFromArray:self.toSearchDict[k]];
        }
        self.toSearchItems = items;
    }
    
    NSString *regex = @"[a-zA-Z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:field.text];
    if (isValid) {
        NSString *text = field.text.lowercaseString;
        for (NSDictionary *d in self.toSearchItems) {
            NSString *py = [d objectForKey:@"pinyin"];
            NSString *szm = [d objectForKey:@"firstletter"];
            if ([py containsString:text]) {
                [self.results addObject:d];
            }else if ([szm containsString:text]) {
                [self.results addObject:d];
            }
        }
        
    }else {
        NSString *text = field.text;
        for (NSDictionary *d in self.toSearchItems) {
            NSString *name = [d objectForKey:@"name"];
            if ([name containsString:text]) {
                [self.results addObject:d];
            }
        }
    }
    
    [self.resultTableView reloadData];
}

#pragma mark - Notification
#pragma mark - Delegate

//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
////    
////    NSString *inputStr = searchController.searchBar.text ;
////    if (self.results.count > 0) {
////        [self.results removeAllObjects];
////    }
////    for (NSString *str in self.datas) {
////        
////        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
////            
////            [self.results addObject:str];
////        }
////    }
////    
//    [self.tableView reloadData];
//}
//
////- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
////    return 44.0f;
////}

#pragma mark - Class

@end
