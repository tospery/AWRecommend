//
//  JXPickerView.m
//  JXObjc
//
//  Created by 杨建祥 on 16/1/16.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXPickerView.h"
#import "JXObjc.h"

#define kJXDatePickerBottomHeight               (200)
#define kJXDatePickerPickerHeight               (160)
#define kJXDatePickerButtonOffset               (2)
#define kJXDatePickerButtonWidth                (90)
#define kJXDatePickerButtonHeight               (34)

typedef NS_ENUM(NSInteger, JXPickerType){
    JXPickerTypeDatetime,
    JXPickerTypeSingle,
    JXPickerTypePairRelated,
    JXPickerTypePairSeparated,
    JXPickerTypeThree,
    JXPickerTypePCZ,            // 省市区
    JXPickerTypeCZ              // 市区
};

@interface JXPickerView ()
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) JXPickerType type;

@property (nonatomic, strong) NSDictionary *relatedDict;

//@property (nonatomic, strong) NSArray *provinces;
//@property (nonatomic, strong) NSArray *cities;
//@property (nonatomic, strong) NSArray *zones;

@property (nonatomic, strong) NSDate *dftDate;

@property (nonatomic, assign) NSInteger singleIndex;
@property (nonatomic, strong) NSArray *firsts;
@property (nonatomic, strong) NSArray *seconds;
@end

@implementation JXPickerView
#pragma mark - Override methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self custom];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self custom];
    }
    return self;
}

- (void)dealloc {
    [self removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(JXScreenWidth, JXScreenHeight);
}

#pragma mark - Private methods
- (void)custom {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, JXScreenHeight, JXScreenWidth, JXScreenHeight);
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = JXColorHex(0xF4F4F4);
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:bottomView];
    //    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(self.mas_leading);
    //        make.trailing.equalTo(self.mas_trailing);
    //        make.bottom.equalTo(self.mas_bottom);
    //        make.height.equalTo(@(kJXDatePickerBottomHeight));
    //    }];
    [bottomView exMakeLeading:0 relatedView:self];
    [bottomView exMakeTrailing:0 relatedView:self];
    [bottomView exMakeBottom:0 relatedView:self];
    [bottomView exMakeHeight:kJXDatePickerBottomHeight];
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:container];
    //    [container mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(bottomView.mas_leading);
    //        make.trailing.equalTo(bottomView.mas_trailing);
    //        make.bottom.equalTo(bottomView.mas_bottom);
    //        make.height.equalTo(@(kJXDatePickerPickerHeight));
    //    }];
    [container exMakeLeading:0 relatedView:bottomView];
    [container exMakeTrailing:0 relatedView:bottomView];
    [container exMakeBottom:0 relatedView:bottomView];
    [container exMakeHeight:kJXDatePickerPickerHeight];
    
    UIImageView *separatorTop = [[UIImageView alloc] init];
    separatorTop.backgroundColor = JXColorHex(0xE1E1E1);
    separatorTop.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:separatorTop];
    //    [separatorTop mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(self.mas_leading);
    //        make.trailing.equalTo(self.mas_trailing);
    //        make.top.equalTo(bottomView.mas_top);
    //        make.height.equalTo(@(1));
    //    }];
    [separatorTop exMakeLeading:0 relatedView:self];
    [separatorTop exMakeTrailing:0 relatedView:self];
    [separatorTop exMakeTop:0 relatedView:self];
    [separatorTop exMakeHeight:1];
    
    UIImageView *separatorBottom = [[UIImageView alloc] init];
    separatorBottom.backgroundColor = JXColorHex(0xE1E1E1);
    separatorBottom.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:separatorBottom];
    //    [separatorBottom mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(self.mas_leading);
    //        make.trailing.equalTo(self.mas_trailing);
    //        make.bottom.equalTo(container.mas_top);
    //        make.height.equalTo(@(1));
    //    }];
    [separatorBottom exMakeLeading:0 relatedView:self];
    [separatorBottom exMakeTrailing:0 relatedView:self];
    [separatorBottom exMakeHeight:1];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:separatorBottom attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [self addConstraint:constraint];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:self.datePicker];
    //    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(container.mas_leading);
    //        make.trailing.equalTo(container.mas_trailing);
    //        make.top.equalTo(container.mas_top);
    //        make.bottom.equalTo(container.mas_bottom);
    //    }];
    [self.datePicker exMakeLeading:0 relatedView:container];
    [self.datePicker exMakeTrailing:0 relatedView:container];
    [self.datePicker exMakeTop:0 relatedView:container];
    [self.datePicker exMakeBottom:0 relatedView:container];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:self.pickerView];
    //    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(container.mas_leading);
    //        make.trailing.equalTo(container.mas_trailing);
    //        make.top.equalTo(container.mas_top);
    //        make.bottom.equalTo(container.mas_bottom);
    //    }];
    [self.pickerView exMakeLeading:0 relatedView:container];
    [self.pickerView exMakeTrailing:0 relatedView:container];
    [self.pickerView exMakeTop:0 relatedView:container];
    [self.pickerView exMakeBottom:0 relatedView:container];
    
    [self.pickerView setHidden:YES];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.titleLabel.font = [UIFont jx_deviceRegularFontOfSize:17.0f];
    [self.cancelButton setTitleColor:JXColorHex(0x4876FF) forState:UIControlStateNormal];
    [self.cancelButton setTitle:kStringCancel forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.cancelButton];
    //    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(bottomView.mas_leading).offset(0);
    //        make.bottom.equalTo(container.mas_top).offset(kJXDatePickerButtonOffset * -1);
    //        make.width.equalTo(@(kJXDatePickerButtonWidth));
    //        make.height.equalTo(@(kJXDatePickerButtonHeight));
    //    }];
    [self.cancelButton exMakeLeading:0 relatedView:bottomView];
    [self.cancelButton exMakeWidth:kJXDatePickerButtonWidth];
    [self.cancelButton exMakeHeight:kJXDatePickerButtonHeight];
    constraint = [NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTop multiplier:1.0 constant:(kJXDatePickerButtonOffset * -1)];
    [self addConstraint:constraint];
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okButton.titleLabel.font = [UIFont jx_deviceRegularFontOfSize:17.0f];
    [self.okButton setTitleColor:JXColorHex(0x4876FF) forState:UIControlStateNormal];
    [self.okButton setTitle:kStringOK forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.okButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.okButton];
    //    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.trailing.equalTo(bottomView.mas_trailing).offset(0);
    //        make.bottom.equalTo(container.mas_top).offset(kJXDatePickerButtonOffset * -1);
    //        make.width.equalTo(self.cancelButton);
    //        make.height.equalTo(self.cancelButton);
    //    }];
    [self.okButton exMakeTrailing:0 relatedView:bottomView];
    [self.okButton exMakeWidth:kJXDatePickerButtonWidth];
    [self.okButton exMakeHeight:kJXDatePickerButtonHeight];
    constraint = [NSLayoutConstraint constraintWithItem:self.okButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTop multiplier:1.0 constant:(kJXDatePickerButtonOffset * -1)];
    [self addConstraint:constraint];
    
    self.fgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fgButton.backgroundColor = [UIColor blackColor];
    self.fgButton.alpha = 0;
    [self.fgButton addTarget:self action:@selector(fdButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.fgButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.fgButton];
    //    [self.fgButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(self.mas_leading);
    //        make.top.equalTo(self.mas_top);
    //        make.trailing.equalTo(self.mas_trailing);
    //        make.bottom.equalTo(bottomView.mas_top);
    //    }];
    [self.fgButton exMakeLeading:0 relatedView:self];
    [self.fgButton exMakeTop:0 relatedView:self];
    [self.fgButton exMakeTrailing:0 relatedView:self];
    constraint = [NSLayoutConstraint constraintWithItem:self.fgButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [self addConstraint:constraint];
}

- (NSInteger)column {
    if (0 == _column) {
        if (JXPickerTypeDatetime == _type ||
            JXPickerTypeSingle == _type) {
            _column = 1;
        }else if (JXPickerTypePairRelated == _type ||
                  JXPickerTypePairSeparated == _type) {
            _column = 2;
        }else if (JXPickerTypeThree == _type) {
            _column = 3;
        }else {
            _column = 0;
        }
    }
    return _column;
}

- (void)setType:(JXPickerType)type {
    _type = type;
    
    BOOL isDatetime = (JXPickerTypeDatetime == type);
    [_datePicker setHidden:!isDatetime];
    [_pickerView setHidden:isDatetime];
}

#pragma mark - Public methods
- (void)loadDatetimeWithCurrent:(NSDate *)current
                    selectBlock:(JXPickerWillCloseBlock)selectBlock {
    self.type = JXPickerTypeDatetime;
    _dftDate = current;
    
    _datePicker.date = current;
    
    self.willCloseBlock = selectBlock;
}

- (void)loadSingleData:(NSArray *)data
               current:(NSInteger)index
           selectBlock:(JXPickerWillCloseBlock)selectBlock {
    self.type = JXPickerTypeSingle;
    
    _firsts = data;
    [_pickerView reloadAllComponents];

    _singleIndex = index;
    [self.pickerView selectRow:_singleIndex inComponent:0 animated:NO];
    
    self.willCloseBlock = selectBlock;
}

- (void)loadData:(NSDictionary *)data
        firstDft:(NSString *)firstDft
       secondDft:(NSString *)secondDft {
    self.type = JXPickerTypePairRelated;
    
    _relatedDict = data;
    [_pickerView reloadAllComponents];
    
    _firsts = [[_relatedDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [_pickerView reloadComponent:0];
    
    NSInteger index = [_firsts indexOfObject:firstDft];
    index = (index == NSNotFound) ? 0 : index;
    [self.pickerView selectRow:index inComponent:0 animated:NO];
    
    NSString *parentValue = _firsts[index];
    _seconds = [_relatedDict[parentValue] sortedArrayUsingSelector:@selector(compare:)];
    [_pickerView reloadComponent:1];
    
    index = [_seconds indexOfObject:secondDft];
    index = (index == NSNotFound) ? 0 : index;
    [_pickerView selectRow:index inComponent:1 animated:NO];
}

- (void)loadDataWithFirsts:(NSArray *)firsts
                   seconds:(NSArray *)seconds
                  firstDft:(NSString *)firstDft
                 secondDft:(NSString *)secondDft {
    self.type = JXPickerTypePairSeparated;
    
    _firsts = firsts;
    _seconds = seconds;
    [_pickerView reloadAllComponents];
    
    NSInteger index = [firsts indexOfObject:firstDft];
    index = (index == NSNotFound) ? 0 : index;
    [self.pickerView selectRow:index inComponent:0 animated:NO];
    
    index = [seconds indexOfObject:secondDft];
    index = (index == NSNotFound) ? 0 : index;
    [self.pickerView selectRow:index inComponent:1 animated:NO];
}

#ifdef JXEnableAppAviationWeather
//- (void)loadDataWithProvinces:(NSArray *)provinces
//                     province:(JXProvince *)province
//                         city:(JXCity *)city
//                         zone:(JXZone *)zone {
//    _num = 3;
//
//    _provinces = provinces;
//
//    JXProvince *p = province;
//    if (!province) {
//        p = provinces[0];
//    }
//    _cities = [JXAddressManager findCitiesWithProvince:p];
//
//    JXCity *c = city;
//    if (!city) {
//        c = _cities[0];
//    }
//    _zones = [JXAddressManager findZonesWithCity:c];
//
//    [self.datePicker setHidden:YES];
//    [self.pickerView setHidden:NO];
//    self.type = JXPickerTypePCZ;
//    [self.pickerView reloadAllComponents];
//}
//
//- (void)loadDataWithCities:(NSArray *)cities
//                         city:(JXCity *)city
//                         zone:(JXZone *)zone {
//    _num = 2;
//    _cities = cities;
//
//    JXCity *c = city;
//    if (!city) {
//        c = _cities[0];
//    }
//    _zones = [JXAddressManager findZonesWithCity:c];
//
//    [self.datePicker setHidden:YES];
//    [self.pickerView setHidden:NO];
//    self.type = JXPickerTypeCZ;
//    [self.pickerView reloadAllComponents];
//}
#endif

- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)show {
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    if (show) {
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.fgButton.alpha = 0.4f;
            }];
        }];
    }else {
        self.fgButton.alpha = 0;
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Action methods
- (void)fdButtonPressed:(id)sender {
    [self show:NO];
    if (self.willCloseBlock) {
        self.willCloseBlock(NO);
    }
}

- (void)cancelButtonPressed:(id)sender {
    [self show:NO];
    if (self.willCloseBlock) {
        self.willCloseBlock(NO);
    }
}

- (void)okButtonPressed:(id)sender {
    [self show:NO];
    if (self.willCloseBlock) {
        BOOL changed = YES;
        
        if (JXPickerTypeDatetime == _type) {
            NSDate *date = _datePicker.date;
            if ([date isEqualToDate:_dftDate]) {
                changed = NO;
            }else {
                _dftDate = date;
            }
        }else if (JXPickerTypeSingle == self.type) {
            NSInteger selectedIndex = [_pickerView selectedRowInComponent:0];
            if (_singleIndex == selectedIndex) {
                changed = NO;
            }else {
                _singleIndex = selectedIndex;
            }
        }
        self.willCloseBlock(changed);
    }
}

#pragma mark - Delegate
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.column; //self.type;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //    if(JXPickerTypeSingle == self.type) {
    //        return self.singleData.count;
    //    }else if (JXPickerTypeRelated == self.type) {
    //        if (component == 0) {
    //            return self.parents.count;
    //        } else {
    //            return self.children.count;
    //        }
    //    }else if (JXPickerTypeIndependent == self.type) {
    //        if (component == 0) {
    //            return _firsts.count;
    //        }else {
    //            return _seconds.count;
    //        }
    //    }else if (JXPickerTypePCZ == self.type) {
    //        if (component == 0) {
    //            return self.provinces.count;
    //        }else if (component == 1) {
    //            return self.cities.count;
    //        }else {
    //            return self.zones.count;
    //        }
    //    }else {
    //        if (component == 0) {
    //            return self.cities.count;
    //        }else {
    //            return self.zones.count;
    //        }
    //    }
    NSInteger rows = 0;
    switch (_type) {
        case JXPickerTypeSingle: {
            rows = _firsts.count;
            break;
        }
        case JXPickerTypePairRelated:
        case JXPickerTypePairSeparated: {
            if (component == 0) {
                rows =  _firsts.count;
            }else {
                rows =  _seconds.count;
            }
            break;
        }
        case JXPickerTypeThree: {
            break;
        }
        default:
            break;
    }
    return rows;
}

#pragma mark UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //    if(JXPickerTypeSingle == self.type) {
    //        return self.singleData[row];
    //    }else if (JXPickerTypeRelated == self.type) {
    //        if (component == 0) {
    //            return self.parents[row];
    //        } else {
    //            return self.children[row];
    //        }
    //    }else if (JXPickerTypeIndependent == self.type) {
    //        if (component == 0) {
    //            return _firsts[row];
    //        }else {
    //            return _seconds[row];
    //        }
    //    }else if (JXPickerTypePCZ == self.type) {
    ////        if (component == 0) {
    ////            return [self.provinces[row] name];
    ////        }else if (component == 1) {
    ////            return [self.cities[row] name];
    ////        }else {
    ////            return [self.zones[row] name];
    ////        }
    //        return nil;
    //    }else {
    //        if (component == 0) {
    //            return [self.cities[row] name];
    //        }else {
    //            return [self.zones[row] name];
    //        }
    //    }
    
    NSString *title = nil;
    switch (_type) {
        case JXPickerTypeSingle: {
            title = [_firsts[row] description];
            break;
        }
        case JXPickerTypePairRelated:
        case JXPickerTypePairSeparated: {
            if (component == 0) {
                title = _firsts[row];
            }else {
                title = _seconds[row];
            }
            break;
        }
        case JXPickerTypeThree: {
            break;
        }
        default:
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //    if(JXPickerTypeSingle == self.type) {
    //        return;
    //    }else if (JXPickerTypeRelated == self.type) {
    //            if (0 == component) {
    //                NSString *parentValue = self.parents[row];
    //                self.children = [self.relatedData[parentValue] sortedArrayUsingSelector:@selector(compare:)];
    //                [self.pickerView reloadComponent:1];
    //                [self.pickerView selectRow:0 inComponent:1 animated:NO];
    //            }
    //    }else if (JXPickerTypePCZ == self.type) {
    ////        if (0 == component) {
    ////            JXProvince *p = self.provinces[row];
    ////            _cities = [JXAddressManager findCitiesWithProvince:p];
    ////            [self.pickerView reloadComponent:1];
    ////            [self.pickerView selectRow:0 inComponent:1 animated:NO];
    ////
    ////            JXCity *c = _cities[0];
    ////            _zones = [JXAddressManager findZonesWithCity:c];
    ////            [_pickerView reloadComponent:2];
    ////            [_pickerView selectRow:0 inComponent:2 animated:NO];
    ////        }else if (1 == component) {
    ////            JXCity *c = _cities[row];
    ////            _zones = [JXAddressManager findZonesWithCity:c];
    ////            [_pickerView reloadComponent:2];
    ////            [_pickerView selectRow:0 inComponent:2 animated:NO];
    ////        }
    //    }else {
    //        if (0 == component) {
    ////            JXCity *c = _cities[row];
    ////            _zones = [JXAddressManager findZonesWithCity:c];
    ////            [_pickerView reloadComponent:1];
    ////            [_pickerView selectRow:0 inComponent:1 animated:NO];
    //        }
    //    }
    
    switch (_type) {
        case JXPickerTypeSingle: {
            break;
        }
        case JXPickerTypePairRelated: {
            if (0 == component) {
                NSString *first = _firsts[row];
                _seconds = [_relatedDict[first] sortedArrayUsingSelector:@selector(compare:)];
                [_pickerView reloadComponent:1];
                [_pickerView selectRow:0 inComponent:1 animated:NO];
            }
            break;
        }
        case JXPickerTypePairSeparated: {
            break;
        }
        case JXPickerTypeThree: {
            break;
        }
        default:
            break;
    }
}
@end
