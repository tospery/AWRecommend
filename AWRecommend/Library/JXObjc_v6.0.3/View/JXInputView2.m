//
//  JXInputView.m
//  JXObjc
//
//  Created by 杨建祥 on 16/1/16.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXInputView2.h"
#import "JXObjc.h"

typedef NS_ENUM(NSInteger, JXInputStyle){
    JXInputStyleDatetime,
    JXInputStyleSingle,
    JXInputStylePairRelated,
    JXInputStylePairSeparated
};

@interface JXInputView2 ()
@property (nonatomic, assign) BOOL once;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) JXInputStyle style;
@property (nonatomic, copy) JXVoidBlock_id selectBlock;
//@property (nonatomic, assign) NSInteger defaultProvinceID;
//@property (nonatomic, assign) NSInteger defaultCityID;
//@property (nonatomic, assign) NSInteger defaultZoneID;
//@property (nonatomic, strong) NSArray  *provinces, *cities, *zones;
//@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, assign) NSInteger singleIndex;
@property (nonatomic, strong) NSArray *singleData;

@end

@implementation JXInputView2
- (instancetype)init {
    if (self = [self initWithFrame:CGRectMake(0, 0, JXScreenWidth, 180.0f)]) {
    }
    return self;
}

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

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (_once) {
        _once = NO;
        return;
    }
    _once = YES;
    
    if (_selectBlock) {
        switch (_style) {
            case JXInputStyleDatetime: {
                if (_selectBlock) {
                    _selectBlock(_datePicker.date);
                }
                break;
            }
            case JXInputStyleSingle: {
                if (_selectBlock) {
                    _selectBlock([_singleData objectAtIndex:_singleIndex]);
                }
                break;
            }
            case JXInputStylePairRelated: {
                break;
            }
            case JXInputStylePairSeparated: {
                break;
            }
                
            default:
                break;
        }
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(JXScreenWidth, 180.0f);
}

#pragma mark - Public methods
- (void)loadDatetimeWithCurrent:(NSDate *)current
                    selectBlock:(JXVoidBlock_id)selectBlock {
    _style = JXInputStyleDatetime;
    _selectBlock = selectBlock;
    _datePicker.date = current;
}

- (void)loadSingleData:(NSArray *)data
               current:(NSInteger)index
           selectBlock:(JXVoidBlock_id)selectBlock {
    _style = JXInputStyleSingle;
    _singleData = data;
    _singleIndex = index;
    _selectBlock = selectBlock;
    
    [_datePicker setHidden:YES];
    [_pickerView setHidden:NO];
    
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:index inComponent:0 animated:NO];
}

#pragma mark - Private methods
- (void)custom {
    _datePicker = [[UIDatePicker alloc] init];
    [_datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_datePicker];
    [_datePicker exMakeConstraintsEdges];
    
    //    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self);
    //    }];
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_pickerView];
    [_pickerView exMakeConstraintsEdges];
    
    //    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self);
    //    }];
    [_pickerView setHidden:YES];
}

- (NSInteger)column {
    if (0 == _column) {
        if (JXInputStyleDatetime == _style ||
            JXInputStyleSingle == _style) {
            _column = 1;
        }else if (JXInputStylePairRelated == _style ||
                  JXInputStylePairSeparated == _style) {
            _column = 2;
        }else {
            _column = 0;
        }
    }
    return _column;
}

- (void)dateValueChanged:(UIDatePicker *)datePicker {
    if (_selectBlock) {
        _selectBlock(datePicker.date);
    }
}

//- (void)setType:(JXInputType)type {
//    _type = type;
//
//    BOOL isDatetime = (JXInputTypeDatetime == type);
//    [_datePicker setHidden:!isDatetime];
//    [_pickerView setHidden:isDatetime];
//}
//
//- (void)loadData:(NSDate *)current{
//    self.type = JXInputTypeDatetime;
//}

#pragma mark - Delegate
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.column;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger result = 0;
    
    switch (_style) {
        case JXInputStyleDatetime: {
            break;
        }
        case JXInputStyleSingle: {
            result = _singleData.count;
            break;
        }
        case JXInputStylePairRelated:
        case JXInputStylePairSeparated: {
            result = 2;
            break;
        }
        default:
            break;
    }
    
    return result;
}

#pragma mark UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *result = nil;
    
    switch (_style) {
        case JXInputStyleSingle: {
            NSString *title = nil;
            id obj = _singleData[row];
            if ([obj isKindOfClass:[NSString class]]) {
                title = obj;
            }else {
                title = [obj description];
            }
//#ifdef JXEnableAppAviationWeather
//            else if ([obj isKindOfClass:[HkbwType class]]) {
//                title = [(HkbwType *)obj text];
//            }else if ([obj isKindOfClass:[HktxType class]]) {
//                title = [(HktxType *)obj text];
//            }else {
//                JXLogError(@"未判断的数据类型！！！");
//            }
//#endif
            result = title;
            break;
        }
        case JXInputStylePairRelated:
        case JXInputStylePairSeparated: {
            break;
        }
        default:
            break;
    }
    
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (_style) {
        case JXInputStyleSingle: {
            _singleIndex = row;
            if (_selectBlock) {
                _selectBlock(_singleData[row]);
            }
            break;
        }
        case JXInputStylePairRelated:
        case JXInputStylePairSeparated: {
            break;
        }
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
@end
