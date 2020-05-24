//
//  AlertViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 17/2/21.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "JXViewController.h"


@interface AlertViewController : JXViewController
@property (nonatomic, copy) NSString *message;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, copy) JXVoidBlock_int didOkBlock;

@end
