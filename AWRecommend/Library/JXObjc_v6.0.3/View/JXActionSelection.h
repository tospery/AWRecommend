//
//  JXActionSelection.h
//  JXSamples
//
//  Created by 杨建祥 on 16/6/2.
//  Copyright © 2016年 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>


#define JXActionBarTagBegin            (543491)


@class JXActionSelection;
@class JXActionSelectionContent;

@protocol JXActionSelectionDelegate <NSObject>
@required
- (void)actionSelection:(JXActionSelection *)selection didSelectIndex:(NSInteger)index withObject:(id)obj;

@end

//@interface JXActionSelectionContent : UIView
//@property (nonatomic, weak) IBOutlet id<JXActionSelectionDelegate> delegate;
//
//@end

@interface JXActionSelection : UIView
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) JXActionSelectionContent *contentView;
@property (nonatomic, weak) id<JXActionSelectionDelegate> delegate;
@property (nonatomic, strong) UIView *coverView;

@end
