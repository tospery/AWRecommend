//
//  JXFlexCellHelper.m
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXFlexCellHelper.h"

@interface JXFlexCellHelper ()
@property (nonatomic, assign, readwrite) JXFlexCellHelperMode mode;
@property (nonatomic, strong, readwrite) NSDictionary *heightDict;
@end

@implementation JXFlexCellHelper
- (instancetype)init {
    if (self = [self initWithMode:JXFlexCellHelperModeFixed fixedHeight:0 collapsedHeight:0 expandedHeight:0]) {
    }
    return self;
}

- (instancetype)initWithMode:(JXFlexCellHelperMode)mode
                 fixedHeight:(CGFloat)fixedHeight
             collapsedHeight:(CGFloat)collapsedHeight
              expandedHeight:(CGFloat)expandedHeight {
    if (self = [super init]) {
        _mode = mode;
        
        NSMutableDictionary *heightDict = [NSMutableDictionary dictionary];
        [heightDict setObject:[NSNumber numberWithFloat:fixedHeight] forKey:kJXFlexCellHelperHeightFixed];
        [heightDict setObject:[NSNumber numberWithFloat:collapsedHeight] forKey:kJXFlexCellHelperHeightCollapsed];
        [heightDict setObject:[NSNumber numberWithFloat:expandedHeight] forKey:kJXFlexCellHelperHeightExpanded];
        _heightDict = heightDict;
    }
    return self;
}

- (void)reverseMode {
    if (JXFlexCellHelperModeFixed == _mode) {
        return;
    }
    
    if (JXFlexCellHelperModeCollapsed == _mode) {
        _mode = JXFlexCellHelperModeExpanded;
    }else {
        _mode = JXFlexCellHelperModeCollapsed;
    }
}
@end
