//
//  JXFlexCellHelper.h
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kJXFlexCellHelperHeightFixed                      (@"kJXFlexCellHelperHeightFixed")
#define kJXFlexCellHelperHeightCollapsed                  (@"kJXFlexCellHelperHeightCollapsed")
#define kJXFlexCellHelperHeightExpanded                   (@"kJXFlexCellHelperHeightExpanded")


typedef NS_ENUM(NSInteger, JXFlexCellHelperMode) {
    JXFlexCellHelperModeFixed,
    JXFlexCellHelperModeCollapsed,
    JXFlexCellHelperModeExpanded
};

@interface JXFlexCellHelper : NSObject
@property (nonatomic, assign, readonly) JXFlexCellHelperMode mode;
@property (nonatomic, strong, readonly) NSDictionary *heightDict;

- (instancetype)initWithMode:(JXFlexCellHelperMode)mode
                 fixedHeight:(CGFloat)fixedHeight
             collapsedHeight:(CGFloat)collapsedHeight
              expandedHeight:(CGFloat)expandedHeight;
- (void)reverseMode;
@end
