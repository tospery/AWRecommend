//
//  JXInputView.m
//  JXSamples
//
//  Created by 杨建祥 on 2017/7/31.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXInputView.h"

@interface JXInputView ()
@property (nonatomic, assign) BOOL once;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) JXInputType type;
@property (nonatomic, copy) JXVoidBlock_id selectBlock;
//@property (nonatomic, assign) NSInteger defaultProvinceID;
//@property (nonatomic, assign) NSInteger defaultCityID;
//@property (nonatomic, assign) NSInteger defaultZoneID;
//@property (nonatomic, strong) NSArray  *provinces, *cities, *zones;
//@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, assign) NSInteger singleIndex;
@property (nonatomic, strong) NSArray *singleData;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation JXInputView
#pragma mark - Override
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

- (CGSize)intrinsicContentSize {
    return CGSizeMake(JXAdaptScreenWidth(), JXAdaptScreen(180.0f));
}

#pragma mark - Accessor
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        _datePicker.hidden = YES;
    }
    return _datePicker;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.hidden = YES;
    }
    return _pickerView;
}

#pragma mark - Private
- (void)custom {
    self.frame = CGRectMake(0, 0, JXAdaptScreenWidth(), JXAdaptScreen(180.0f));
    
    [self addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (NSInteger)totalColumns {
    NSInteger ret = 0;
    switch (self.type) {
        case JXInputTypeDatetime:
        case JXInputTypeSingle:
            ret = 1;
            break;
        case JXInputTypePairSeparated:
        case JXInputTypePairRelated:
            ret = 2;
            break;
        default:
            break;
    }
    
    return ret;
}

#pragma mark - Public
- (void)loadDatetimeWithCurrent:(NSDate *)current
                    selectBlock:(JXVoidBlock_id)selectBlock {
    self.type = JXInputTypeDatetime;
    self.selectBlock = selectBlock;
    
    self.datePicker.date = current;
    
    self.datePicker.hidden = NO;
    self.pickerView.hidden = YES;
}

- (void)loadSingleData:(NSArray *)data
               current:(NSInteger)index
           selectBlock:(JXVoidBlock_id)selectBlock {
    self.type = JXInputTypeSingle;
    self.selectBlock = selectBlock;
    self.dataSource = data;
    
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:index inComponent:0 animated:NO];

    self.datePicker.hidden = YES;
    self.pickerView.hidden = NO;
}

#pragma mark - Action
- (void)datePickerValueChanged:(UIDatePicker *)datePicker {
    //    if (_selectBlock) {
    //        _selectBlock(datePicker.date);
    //    }
}

#pragma mark - Notification
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self totalColumns];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger ret = 0;
    switch (self.type) {
        case JXInputTypeDatetime:
            break;
        case JXInputTypeSingle:
            ret = self.dataSource.count;
            break;
        case JXInputTypePairSeparated:
        case JXInputTypePairRelated:
            break;
        default:
            break;
    }
    return ret;
}

#pragma mark UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *ret = nil;
    switch (self.type) {
        case JXInputTypeDatetime:
            break;
        case JXInputTypeSingle: {
            id obj = self.dataSource[row];
            if ([obj isKindOfClass:[NSString class]]) {
                ret = obj;
            }else {
                ret = [obj description];
            }
            break;
        }
        case JXInputTypePairSeparated:
        case JXInputTypePairRelated:
            break;
        default:
            break;
    }
    return ret;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.type) {
        case JXInputTypeDatetime:
            break;
        case JXInputTypeSingle: {
            if (self.selectBlock) {
                self.selectBlock(self.dataSource[row]);
            }
            break;
        }
        case JXInputTypePairSeparated:
        case JXInputTypePairRelated:
            break;
        default:
            break;
    }
    
    //    if(JXPickerTypeSingle == self.type) {
    //        return;
    //    }else if (JXPickerTypeRelated == self.type) {
    //        if (0 == component) {
    //            NSString *parentValue = self.parents[row];
    //            self.children = [self.relatedData[parentValue] sortedArrayUsingSelector:@selector(compare:)];
    //            [self.pickerView reloadComponent:1];
    //            [self.pickerView selectRow:0 inComponent:1 animated:NO];
    //        }
    //    }else if (JXPickerTypePCZ == self.type) {
    //        if (0 == component) {
    //            JXProvince *p = self.provinces[row];
    //            _cities = [JXAddressManager findCitiesWithProvince:p];
    //            [self.pickerView reloadComponent:1];
    //            [self.pickerView selectRow:0 inComponent:1 animated:NO];
    //
    //            JXCity *c = _cities[0];
    //            _zones = [JXAddressManager findZonesWithCity:c];
    //            [_pickerView reloadComponent:2];
    //            [_pickerView selectRow:0 inComponent:2 animated:NO];
    //        }else if (1 == component) {
    //            JXCity *c = _cities[row];
    //            _zones = [JXAddressManager findZonesWithCity:c];
    //            [_pickerView reloadComponent:2];
    //            [_pickerView selectRow:0 inComponent:2 animated:NO];
    //        }
    //    }else {
    //        if (0 == component) {
    //            //            JXCity *c = _cities[row];
    //            //            _zones = [JXAddressManager findZonesWithCity:c];
    //            //            [_pickerView reloadComponent:1];
    //            //            [_pickerView selectRow:0 inComponent:1 animated:NO];
    //        }
    //    }
}

#pragma mark - Delegate
#pragma mark - Class

@end
