//
//  JXInputView.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/16.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JXInputViewSelectBlock)(id val1, id val2, id val3);

@interface JXInputView2 : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;

- (void)loadDatetimeWithCurrent:(NSDate *)current
                    selectBlock:(JXVoidBlock_id)selectBlock JXAPIDeprecated601;

- (void)loadSingleData:(NSArray *)data
               current:(NSInteger)index
           selectBlock:(JXVoidBlock_id)selectBlock JXAPIDeprecated601;


@end
