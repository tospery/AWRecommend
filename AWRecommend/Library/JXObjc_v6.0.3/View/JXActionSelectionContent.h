//
//  JXActionSelectionContent.h
//  JXSamples
//
//  Created by 杨建祥 on 16/6/2.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXActionSelection.h"

@interface JXActionSelectionContent : UIView
@property (nonatomic, weak) IBOutlet id<JXActionSelectionDelegate> delegate;

@end
