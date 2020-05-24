//
//  JXInputView.h
//  JXSamples
//
//  Created by 杨建祥 on 2017/7/31.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXInputType){
    JXInputTypeDatetime,
    JXInputTypeSingle,
    JXInputTypePairSeparated,
    JXInputTypePairRelated
};

// JXPickerInputView
@interface JXInputView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;


@end
