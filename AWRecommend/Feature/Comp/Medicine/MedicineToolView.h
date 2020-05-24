//
//  MedicineToolView.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/3/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicineToolView : UIView
@property (nonatomic, copy) JXVoidBlock shareBlock;
@property (nonatomic, copy) JXVoidBlock_bool favoriteBlock;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;

@end
