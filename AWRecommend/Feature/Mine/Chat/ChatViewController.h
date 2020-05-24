//
//  ChatViewController.h
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "DemoModelData.h"

@class ChatViewController;

@protocol JSQDemoViewControllerDelegate <NSObject>
- (void)didDismissJSQDemoViewController:(ChatViewController *)vc;

@end

@interface ChatViewController : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate>
@property (nonatomic, strong) NSArray *msgs;
//@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;
//@property (strong, nonatomic) DemoModelData *demoData;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;
- (void)closePressed:(UIBarButtonItem *)sender;

@property (nonatomic, strong) Doctor *doctor;

@end
