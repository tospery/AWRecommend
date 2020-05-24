//
//  ProfileAvatarCell.m
//  AWRecommend
//
//  Created by 杨建祥 on 2017/5/17.
//  Copyright © 2017年 杨建祥. All rights reserved.
//

#import "ProfileAvatarCell.h"

@interface ProfileAvatarCell() <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIPopoverController *popoverController;
    UIImagePickerController *imagePickerController;
    UIAlertController *alertController;
}

@end

@implementation ProfileAvatarCell
+(void)load {
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([ProfileAvatarCell class]) forKey:XLFormRowDescriptorTypeAvatar];
}

+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return JXAdaptScreen(50);
}

- (void)configure {
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, JXAdaptScreen(40), JXAdaptScreen(40))];
    [avatarImageView jx_circleWithColor:[UIColor clearColor] border:0.0];
    
    self.accessoryView = avatarImageView;
    self.editingAccessoryView = self.accessoryView;
}

- (void)update {
    [super update];
    self.textLabel.font = JXFont(14);
    self.textLabel.text = self.rowDescriptor.title;
    self.imageView.image = self.rowDescriptor.value;
}

- (void)chooseImage:(UIImage *)image {
    self.imageView.image = image;
    self.rowDescriptor.value = image;
}

- (UIImageView *)imageView {
    return (UIImageView *)self.accessoryView;
}

- (void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller {
    alertController = [UIAlertController alertControllerWithTitle: self.rowDescriptor.title
                                                          message: nil
                                                   preferredStyle: UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle: @"从相册选择一张图片"
                                                        style: UIAlertActionStyleDefault
                                                      handler: ^(UIAlertAction * _Nonnull action) {
                                                          [self openImage:UIImagePickerControllerSourceTypePhotoLibrary];
                                                      }]];
    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        [alertController addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Take Photo", nil)
//                                                            style: UIAlertActionStyleDefault
//                                                          handler: ^(UIAlertAction * _Nonnull action) {
//                                                              [self openImage:UIImagePickerControllerSourceTypeCamera];
//                                                          }]];
//    }
    
    [alertController addAction:[UIAlertAction actionWithTitle: @"取消"
                                                        style: UIAlertActionStyleCancel
                                                      handler: nil]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        alertController.popoverPresentationController.sourceView = self.contentView;
        alertController.popoverPresentationController.sourceRect = self.contentView.bounds;
    }
    
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        [self.formViewController presentViewController:self->alertController animated: true completion: nil];
    });
}

- (void)openImage:(UIImagePickerControllerSourceType)source {
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = source;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        [popoverController presentPopoverFromRect: self.contentView.frame
                                           inView: self.formViewController.view
                         permittedArrowDirections: UIPopoverArrowDirectionAny
                                         animated: YES];
    } else {
        [self.formViewController presentViewController: imagePickerController
                                              animated: YES
                                            completion: nil];
    }
}

#pragma mark -  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        [self chooseImage:editedImage];
    } else {
        [self chooseImage:originalImage];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (popoverController && popoverController.isPopoverVisible) {
            [popoverController dismissPopoverAnimated: YES];
        }
    } else {
        [self.formViewController dismissViewControllerAnimated: YES completion: nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.formViewController dismissViewControllerAnimated: YES completion: nil];
}


@end
