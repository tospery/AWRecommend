////
////  JXFilterViewSelection.h
////  MeijiaStore
////
////  Created by 杨建祥 on 16/1/2.
////  Copyright © 2016年 iOS开发组. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//
//#define JXFilterViewTagBegin            (577491)
//
//
//@class JXFilterViewSelection;
//
//@protocol JXFilterViewSelectionDelegate <NSObject>
//@required
//- (void)filterViewSelection:(JXFilterViewSelection *)selection
//             didSelectIndex:(NSInteger)index
//                 withObject:(id)obj;
//
//@end
//
//@interface JXFilterViewSelectionContent : UIView
//@property (nonatomic, weak) IBOutlet id<JXFilterViewSelectionDelegate> delegate;
//
//@end
//
//@interface JXFilterViewSelection : UIView
//@property (nonatomic, assign) CGFloat contentHeight;
//@property (nonatomic, assign) BOOL isAnimating;
//@property (nonatomic, strong) JXFilterViewSelectionContent *contentView;
//@property (nonatomic, weak) id<JXFilterViewSelectionDelegate> delegate;
//
//@end
