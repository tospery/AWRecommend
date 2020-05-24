//
//  ChatViewController.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/10.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatHistoryViewController.h"

@interface ChatViewController () <JSQMessagesViewAccessoryButtonDelegate>
@property (nonatomic, strong) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (nonatomic, assign) NSInteger lastIndex;

@end

@implementation ChatViewController
#pragma mark - View lifecycle
/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self.navigationController.navigationBar jx_configWithParam:@{kJXKeyTranslucent: @NO, kJXKeyBarTintColor: [UIColor whiteColor], kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleFont: JXFont(16.0)}];
//    [self.navigationItem.leftBarButtonItem jx_configWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: JXFont(14)}];
//    [self.navigationItem.rightBarButtonItem jx_configWithParam:@{kJXKeyTitleColor: JXColorHex(0x333333), kJXKeyTitleColorDisabled: [UIColor lightTextColor], kJXKeyTitleFont: JXFont(14)}];
    
    self.navigationItem.leftBarButtonItem = JXCreateBackItem(self, @selector(backItemPressed:), JXColorHex(0x333333));
    //self.additionalContentInset = UIEdgeInsetsMake(-100, 0, 100, 0);
    
    self.title = @"会话";
    
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:JXImageWithName(@"ic_message-chat") forState:UIControlStateNormal];
    self.inputToolbar.contentView.leftBarButtonItem = leftButton;
    //self.inputToolbar.contentView.leftBarButtonItem.userInteractionEnabled = NO;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor = SMInstance.mainColor;
    rightButton.titleLabel.font = JXFont(14);
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton jx_borderWithColor:[UIColor clearColor] width:0.0 radius:4.0];
    self.inputToolbar.contentView.rightBarButtonItem = rightButton;
    self.inputToolbar.contentView.rightBarButtonItemWidth = JXScreenScale(60);
    self.inputToolbar.contentView.textView.placeHolder = nil;
    /**
     *  Load up our fake data for the demo
     */
    // self.demoData = [[DemoModelData alloc] init];
    self.messages = [NSMutableArray arrayWithArray:self.msgs];
    self.lastIndex = self.messages.count;
    
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    /**
     *  Set up message accessory button delegate and configuration
     */
    self.collectionView.accessoryDelegate = self;
    
    /**
     *  You can set custom avatar sizes
     */
    if (/*![NSUserDefaults incomingAvatarSetting]*//* DISABLES CODE */ (NO)) {
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(32, 32); // CGSizeZero;
    }
    
    if (/*![NSUserDefaults outgoingAvatarSetting]*//* DISABLES CODE */ (NO)) {
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(32, 32); //CGSizeZero;
    }
    
    self.showLoadEarlierMessagesHeader = NO; // YES;
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
    //                                                                              style:UIBarButtonItemStylePlain
    //                                                                             target:self
    //                                                                             action:@selector(receiveMessagePressed:)];
    
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    historyButton.titleLabel.font = JXFont(14);
    [historyButton setTitleColor:JXColorHex(0x333333) forState:UIControlStateNormal];
    [historyButton setTitle:@"咨询记录" forState:UIControlStateNormal];
    [historyButton addTarget:self action:@selector(history:) forControlEvents:UIControlEventTouchUpInside];
    [historyButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:historyButton];
    // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"咨询记录" style:UIBarButtonItemStylePlain target:self action:@selector(history:)];
    
    /**
     *  Register custom menu actions for cells.
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    
    
    /**
     *  OPT-IN: allow cells to be deleted
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
    
    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */
    
    /**
     *  Set a maximum height for the input toolbar
     *
     *  self.inputToolbar.maximumHeight = 150;
     */
    
    //    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view).offset(200);
    //    }];
    
    // self.collectionView.frame = CGRectMake(0, 200, JXScreenWidth, JXScreenHeight);
    
    if (self.messages.count == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *welcome = JXStrWithFmt(@"您好，我是健康智选药师%@，如果您有用药方面的问题，我会尽快回复您！", self.doctor.doctorName);
            // JSQMessage *message = [JSQMessage messageWithSenderId:self.doctor.doctorId displayName:self.doctor.doctorName text:welcome];
            JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.doctor.doctorId senderDisplayName:self.doctor.doctorName date:[NSDate date] text:welcome];
            [self.messages addObject:message];
            [self finishReceivingMessageAnimated:YES];
        });
    }
}

- (void)backItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    if (self.delegateModal) {
    //        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
    //                                                                                              target:self
    //                                                                                              action:@selector(closePressed:)];
    //    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyChatDidReceive:) name:kNotifyChatDidReceive object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    self.collectionView.collectionViewLayout.springinessEnabled = NO; //[NSUserDefaults springinessSetting];
}

- (void)notifyChatDidReceive:(NSNotification *)notification {
    NSArray *msgs = notification.object;
    if (msgs == nil) {
        return;
    }
    if (![msgs isKindOfClass:[NSArray class]]) {
        return;
    }
    if (msgs.count == 0) {
        return;
    }
    
    for (TIMMessage *message in msgs) {
        int cnt = [message elemCount];
        
        for (int i = 0; i < cnt; i++) {
            TIMElem *elem = [message getElem:i];
            
            if ([elem isKindOfClass:[TIMTextElem class]]) {
                TIMTextElem *textElem = (TIMTextElem * )elem;
                JSQMessage *msg = [[JSQMessage alloc] initWithSenderId:self.doctor.doctorId senderDisplayName:self.doctor.doctorName date:[NSDate date] text:textElem.text];
                [self.messages addObject:msg];
                [self finishReceivingMessageAnimated:YES];
            }
        }
    }
    
    
    //    copyMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdJobs
    //                                      displayName:kJSQDemoAvatarDisplayNameJobs
    //                                             text:@"First received!"];
    //    [self.messages addObject:newMessage];
    //    [self finishReceivingMessageAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)history:(id)sender {
    ChatHistoryViewController *vc = [[ChatHistoryViewController alloc] init];
    vc.doctor = self.doctor;
    vc.navItemColor = JXColorHex(0x333333);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Custom menu actions for cells
- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification {
    /**
     *  Display custom menu actions for cells.
     */
    UIMenuController *menu = [notification object];
    menu.menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
    
    [super didReceiveMenuWillShowNotification:notification];
}



#pragma mark - Testing

- (void)pushMainViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nc = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:nc.topViewController animated:YES];
}


#pragma mark - Actions

- (void)receiveMessagePressed:(UIBarButtonItem *)sender
{
    /**
     *  DEMO ONLY
     *
     *  The following is simply to simulate received messages for the demo.
     *  Do not actually do this.
     */
    
    
    /**
     *  Show the typing indicator to be shown
     */
    self.showTypingIndicator = !self.showTypingIndicator;
    
    /**
     *  Scroll to actually view the indicator
     */
    [self scrollToBottomAnimated:YES];
    
    /**
     *  Copy last sent message, this will be the new "received" message
     */
    JSQMessage *copyMessage = nil; // [[self.demoData.messages lastObject] copy];
    
    if (!copyMessage) {
        copyMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdJobs
                                          displayName:kJSQDemoAvatarDisplayNameJobs
                                                 text:@"First received!"];
    }
    
    /**
     *  Allow typing indicator to show
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //        NSMutableArray *userIds = [[self.demoData.users allKeys] mutableCopy];
        //        [userIds removeObject:self.senderId];
        NSString *randomUserId = @"D260"; //userIds[arc4random_uniform((int)[userIds count])];
        NSString *randomUserName = @"药师客服";
        
        JSQMessage *newMessage = nil;
        id<JSQMessageMediaData> newMediaData = nil;
        id newMediaAttachmentCopy = nil;
        
        if (copyMessage.isMediaMessage) {
            /**
             *  Last message was a media message
             */
            id<JSQMessageMediaData> copyMediaData = copyMessage.media;
            
            if ([copyMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
                JSQPhotoMediaItem *photoItemCopy = [((JSQPhotoMediaItem *)copyMediaData) copy];
                photoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [UIImage imageWithCGImage:photoItemCopy.image.CGImage];
                
                /**
                 *  Set image to nil to simulate "downloading" the image
                 *  and show the placeholder view
                 */
                photoItemCopy.image = nil;
                
                newMediaData = photoItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
                JSQLocationMediaItem *locationItemCopy = [((JSQLocationMediaItem *)copyMediaData) copy];
                locationItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [locationItemCopy.location copy];
                
                /**
                 *  Set location to nil to simulate "downloading" the location data
                 */
                locationItemCopy.location = nil;
                
                newMediaData = locationItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
                JSQVideoMediaItem *videoItemCopy = [((JSQVideoMediaItem *)copyMediaData) copy];
                videoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [videoItemCopy.fileURL copy];
                
                /**
                 *  Reset video item to simulate "downloading" the video
                 */
                videoItemCopy.fileURL = nil;
                videoItemCopy.isReadyToPlay = NO;
                
                newMediaData = videoItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQAudioMediaItem class]]) {
                JSQAudioMediaItem *audioItemCopy = [((JSQAudioMediaItem *)copyMediaData) copy];
                audioItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [audioItemCopy.audioData copy];
                
                /**
                 *  Reset audio item to simulate "downloading" the audio
                 */
                audioItemCopy.audioData = nil;
                
                newMediaData = audioItemCopy;
            }
            else {
                NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
            }
            
            newMessage = [JSQMessage messageWithSenderId:randomUserId
                                             displayName:randomUserName/*self.demoData.users[randomUserId]*/
                                                   media:newMediaData];
        }
        else {
            /**
             *  Last message was a text message
             */
            newMessage = [JSQMessage messageWithSenderId:randomUserId
                                             displayName:randomUserName/*self.demoData.users[randomUserId]*/
                                                    text:copyMessage.text];
        }
        
        /**
         *  Upon receiving a message, you should:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishReceivingMessage`
         */
        
        // [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
        
        // [self.demoData.messages addObject:newMessage];
        [self.messages addObject:newMessage];
        [self finishReceivingMessageAnimated:YES];
        
        
        if (newMessage.isMediaMessage) {
            /**
             *  Simulate "downloading" media
             */
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /**
                 *  Media is "finished downloading", re-display visible cells
                 *
                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
                 *
                 *  Reload the specific item, or simply call `reloadData`
                 */
                
                if ([newMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
                    ((JSQPhotoMediaItem *)newMediaData).image = newMediaAttachmentCopy;
                    [self.collectionView reloadData];
                }
                else if ([newMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
                    [((JSQLocationMediaItem *)newMediaData)setLocation:newMediaAttachmentCopy withCompletionHandler:^{
                        [self.collectionView reloadData];
                    }];
                }
                else if ([newMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
                    ((JSQVideoMediaItem *)newMediaData).fileURL = newMediaAttachmentCopy;
                    ((JSQVideoMediaItem *)newMediaData).isReadyToPlay = YES;
                    [self.collectionView reloadData];
                }
                else if ([newMediaData isKindOfClass:[JSQAudioMediaItem class]]) {
                    ((JSQAudioMediaItem *)newMediaData).audioData = newMediaAttachmentCopy;
                    [self.collectionView reloadData];
                }
                else {
                    NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
                }
                
            });
        }
        
    });
}

- (void)closePressed:(UIBarButtonItem *)sender {
   
    
    //[self.delegateModal didDismissJSQDemoViewController:self];
}




#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    
    // [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    // [self.demoData.messages addObject:message];
    [self.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
    
    
    TIMConversation *conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:self.doctor.doctorId];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    TIMTextElem *elem = [[TIMTextElem alloc] init];
    [elem setText:text];
    [msg addElem:elem];
    
    [conv sendMessage:msg succ:^(){
        JXLogDebug(@"发送成功");
    }fail:^(int code, NSString *err) {
        JXLogDebug(@"发送失败：%@", err);
    }];
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    //    [self.inputToolbar.contentView.textView resignFirstResponder];
    //
    //    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Media messages", nil)
    //                                                       delegate:self
    //                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
    //                                         destructiveButtonTitle:nil
    //                                              otherButtonTitles:NSLocalizedString(@"Send photo", nil), NSLocalizedString(@"Send location", nil), NSLocalizedString(@"Send video", nil), NSLocalizedString(@"Send video thumbnail", nil), NSLocalizedString(@"Send audio", nil), nil];
    //
    //    [sheet showFromToolbar:self.inputToolbar];
}

//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == actionSheet.cancelButtonIndex) {
//        [self.inputToolbar.contentView.textView becomeFirstResponder];
//        return;
//    }
//
//    switch (buttonIndex) {
//        case 0:
//            [self.demoData addPhotoMediaMessage];
//            break;
//
//        case 1:
//        {
//            __weak UICollectionView *weakView = self.collectionView;
//
//            [self.demoData addLocationMediaMessageCompletion:^{
//                [weakView reloadData];
//            }];
//        }
//            break;
//
//        case 2:
//            [self.demoData addVideoMediaMessage];
//            break;
//
//        case 3:
//            [self.demoData addVideoMediaMessageWithThumbnail];
//            break;
//
//        case 4:
//            [self.demoData addAudioMediaMessage];
//            break;
//    }
//
//    // [JSQSystemSoundPlayer jsq_playMessageSentSound];
//
//    [self finishSendingMessageAnimated:YES];
//}



#pragma mark - JSQMessages CollectionView DataSource
- (NSString *)senderId {
    return JXStrWithFmt(@"A%@", gUser.jxID);
}

- (NSString *)senderDisplayName {
    NSString *name = gUser.nickName;
    if (0 == name.length) {
        name = gUser.mobile;
    }
    if (0 == name.length) {
        name = @"我";
    }
    return name;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    [self.messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    //    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    //
    //    if ([message.senderId isEqualToString:self.senderId]) {
    //        if (/*![NSUserDefaults outgoingAvatarSetting]*/NO) {
    //            return nil;
    //        }
    //    }
    //    else {
    //        if (/*![NSUserDefaults incomingAvatarSetting]*/NO) {
    //            return nil;
    //        }
    //    }
    //
    //
    //    return [self.demoData.avatars objectForKey:message.senderId];
    
    JSQMessagesAvatarImageFactory *factory = [[JSQMessagesAvatarImageFactory alloc] initWithDiameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return [factory avatarImageWithImage:self.doctor.aImage];
    }
    
    return [factory avatarImageWithImage:self.doctor.dImage];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    //    if (indexPath.item % 3 == 0) {
    //        JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    //        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    //    }
    
    if (indexPath.item == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
//    if (indexPath.item != 0 &&
//        indexPath.item == self.lastIndex) {
//        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
//        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
//    }
    
    JSQMessage *curtMessage = [self.messages objectAtIndex:indexPath.item];
    JSQMessage *prevMessage = [self.messages objectAtIndex:(indexPath.item - 1)];
    NSInteger hours = [self getMinutesFrom:curtMessage.date To:prevMessage.date];
    if (hours >= 5) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    cell.accessoryButton.hidden = ![self shouldShowAccessoryButtonForMessage:msg];
    
    return cell;
}

- (BOOL)shouldShowAccessoryButtonForMessage:(id<JSQMessageData>)message
{
    return ([message isMediaMessage] && /*[NSUserDefaults accessoryButtonForMediaMessages]*/YES);
}


#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//    if (action == @selector(customAction:)) {
//        return YES;
//    }
//    
//    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender {
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Custom Action", nil)
                                message:nil
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
//    /**
//     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
//     */
//    
//    /**
//     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
//     *  The other label height delegate methods should follow similarly
//     *
//     *  Show a timestamp for every 3rd message
//     */
//    if (indexPath.item % 3 == 0) {
//        return kJSQMessagesCollectionViewCellLabelHeightDefault;
//    }
//    
//    return 0.0f;
    
    if (indexPath.item == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault; // 显示时间
    }
    
//    if (indexPath.item != 0 &&
//        indexPath.item == self.lastIndex) {
//        return kJSQMessagesCollectionViewCellLabelHeightDefault; // 显示时间
//    }
    
    JSQMessage *curtMessage = [self.messages objectAtIndex:indexPath.item];
    JSQMessage *prevMessage = [self.messages objectAtIndex:(indexPath.item - 1)];
    NSInteger hours = [self getMinutesFrom:curtMessage.date To:prevMessage.date];
    if (hours >= 5) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault; // 显示时间
    }
    
    
    return 0.0;
}

//- (NSInteger)getHoursFrom:(NSDate *)serverDate To:(NSDate *)endDate {
//    NSDate* date1 = serverDate;
//    NSDate* date2 = endDate;
//    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
//    double secondsInAnHour = 3600;
//    return distanceBetweenDates / secondsInAnHour;
//}

- (NSInteger)getMinutesFrom:(NSDate *)serverDate To:(NSDate *)endDate {
    NSDate* date1 = serverDate;
    NSDate* date2 = endDate;
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
    double secondsInAnMinute = 60;
    return distanceBetweenDates / secondsInAnMinute;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods
- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender {
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

#pragma mark - JSQMessagesViewAccessoryDelegate methods

- (void)messageView:(JSQMessagesCollectionView *)view didTapAccessoryButtonAtIndexPath:(NSIndexPath *)path {
    NSLog(@"Tapped accessory button!");
}

@end
