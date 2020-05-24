//
//  JXPickerView.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/16.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JXPickerWillCloseBlock)(BOOL selected);

// https://github.com/skywinder/ActionSheetPicker-3.0
@interface JXPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIButton *fgButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) JXPickerWillCloseBlock willCloseBlock;

/**
 *  加载日期时间选择器
 *
 *  @param current 默认值
 */
- (void)loadDatetimeWithCurrent:(NSDate *)current
                    selectBlock:(JXPickerWillCloseBlock)selectBlock JXAPIDeprecated601;

/**
 *  加载只有一列的数据
 *
 *  @param data    数据
 *  @param index 默认选项
 */
- (void)loadSingleData:(NSArray *)data
               current:(NSInteger)index
           selectBlock:(JXPickerWillCloseBlock)selectBlock JXAPIDeprecated601;

/**
 *  加载相互独立的两列数据
 *
 *  @param firsts    第一列数据
 *  @param seconds   第二列数据
 *  @param firstDft  第一列默认选项
 *  @param secondDft 第二列默认选项
 */
- (void)loadDataWithFirsts:(NSArray *)firsts
                   seconds:(NSArray *)seconds
                  firstDft:(NSString *)firstDft
                 secondDft:(NSString *)secondDft JXAPIDeprecated601;

/**
 *  加载具有关联性的两列数据
 *
 *  @param data      数据
 *  @param firstDft  第一列默认选项
 *  @param secondDft 第二列默认选项
 */
- (void)loadData:(NSDictionary *)data
        firstDft:(NSString *)firstDft
       secondDft:(NSString *)secondDft JXAPIDeprecated601;


#ifdef JXEnableAppAviationWeather
//- (void)loadDataWithProvinces:(NSArray *)provinces
//                     province:(JXProvince *)province
//                         city:(JXCity *)city
//                         zone:(JXZone *)zone;
//- (void)loadDataWithCities:(NSArray *)cities
//                      city:(JXCity *)city
//                      zone:(JXZone *)zone;
#endif

/**
 *  弹出选择器视图
 */
- (void)show;
@end

