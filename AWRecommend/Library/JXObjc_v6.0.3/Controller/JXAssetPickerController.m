//
//  JXAssetPickerController.m
//  JXObjc
//
//  Created by 杨建祥 on 16/1/14.
//  Copyright © 2016年 iOS开发组. All rights reserved.
//

#import "JXAssetPickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "JXObjc.h"

@interface JXAssetPickerController ()
@property (nonatomic, assign) JXAssetPickerMode mode;
@property (nonatomic, copy) JXAssetPickerWillSuccessBlock willSuccess;
@property (nonatomic, copy) JXAssetPickerDidSuccessBlock didSuccess;
@property (nonatomic, copy) JXAssetPickerFailureBlock failure;
@end

@implementation JXAssetPickerController
- (BOOL)setupWithMode:(JXAssetPickerMode)mode
          willSuccess:(JXAssetPickerWillSuccessBlock)willSuccess
           didSuccess:(JXAssetPickerDidSuccessBlock)didSuccess
              failure:(JXAssetPickerFailureBlock)failure {
    _mode = mode;
    _willSuccess = willSuccess;
    _didSuccess = didSuccess;
    _failure = failure;
    
    BOOL result = NO;
    if (JXAssetPickerModeTakePhoto == _mode) {
        result = [self setupWithSourceType:UIImagePickerControllerSourceTypeCamera mediaTypes:@[(__bridge NSString *)kUTTypeImage]];
    }else if (JXAssetPickerModeTakeVideo == _mode) {
        result = [self setupWithSourceType:UIImagePickerControllerSourceTypeCamera mediaTypes:@[(__bridge NSString *)kUTTypeMovie]];
    }else if (JXAssetPickerModeAlbumPhoto == _mode) {
        result = [self setupWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary mediaTypes:@[(__bridge NSString *)kUTTypeImage]];
    }else if (JXAssetPickerModeAlbumVideo == _mode) {
        result = [self setupWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary mediaTypes:@[(__bridge NSString *)kUTTypeMovie]];
    }else if (JXAssetPickerModeAlbumMedia == _mode) {
        result = [self setupWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary mediaTypes:@[(__bridge NSString *)kUTTypeImage, (__bridge NSString *)kUTTypeMovie]];
    }else {
        JXLogError(@"未实现的mode");
    }
    
    return result;
}

- (BOOL)setupWithSourceType:(UIImagePickerControllerSourceType)sourceType
                 mediaTypes:(NSArray *)mediaTypes{
    NSArray *types = mediaTypes;
    NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    for (NSString *type in types) {
        if (![availableTypes containsObject:type]) {
            types = nil;
            break;
        }
    }
    
    if (JXDataIsEmpty(types)) {
        if (_failure) {
            _failure([NSError jx_errorWithCode:JXErrorCodeDeviceNotSupport]);
            _failure = NULL;
        }
        return NO;
    }
    
    self.mediaTypes = mediaTypes;
    self.delegate = self;
    self.allowsEditing = YES;
    self.sourceType = sourceType;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    return YES;
}

- (void)dismissWithImage:(UIImage *)image
                   asset:(ALAsset *)asset {
    if (JXDataIsEmpty(image) &&
        JXDataIsEmpty(asset)) {
        if (_failure) {
            _failure([NSError jx_errorWithCode:JXErrorCodeActionFailure]);
            _failure = NULL;
        }
        return;
    }
    
    if (_willSuccess) {
        _willSuccess(image, asset);
        _willSuccess = NULL;
    }
    
    __weak __typeof(self) wSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        __strong __typeof(wSelf) sSelf = wSelf;
        if (sSelf.didSuccess) {
            sSelf.didSuccess(image, asset);
            sSelf.didSuccess = NULL;
        }
    }];
}

- (void)dismissWithError:(NSError *)error {
    if (_failure) {
        _failure(error);
        _failure = NULL;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    switch (_mode) {
        case JXAssetPickerModeTakePhoto: {
            UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(originalImage, nil, NULL, NULL);
            UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
            [self dismissWithImage:image asset:nil];
        }
            break;
        case JXAssetPickerModeTakeVideo: {
            NSURL *mediaURL = (NSURL *)[info objectForKey:UIImagePickerControllerMediaURL];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaURL.path)) {
                ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
                [lib writeVideoAtPathToSavedPhotosAlbum:mediaURL completionBlock:^(NSURL *assetURL, NSError *error) {
                    if (assetURL) {
                        [lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                            if (asset) {
                                UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                                                     scale:asset.defaultRepresentation.scale
                                                               orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
                                [self dismissWithImage:image asset:asset];
                            }else {
                                [self dismissWithError:[NSError jx_errorWithCode:JXErrorCodeActionFailure]];
                            }
                        } failureBlock:^(NSError *error) {
                            [self dismissWithError:error];
                        }];
                    }else {
                        [self dismissWithError:error];
                    }
                }];
            }else {
                [self dismissWithError:[NSError jx_errorWithCode:JXErrorCodeActionFailure]];
            }
            return;
        }
            break;
        case JXAssetPickerModeAlbumPhoto: {
            UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
            [self dismissWithImage:image asset:nil];
        }
            break;
        case JXAssetPickerModeAlbumVideo: {
            NSURL *assetURL = (NSURL *)[info objectForKey:UIImagePickerControllerReferenceURL];
            ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                                         scale:asset.defaultRepresentation.scale
                                                   orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
                    [self dismissWithImage:image asset:asset];
                }else {
                    [self dismissWithError:[NSError jx_errorWithCode:JXErrorCodeActionFailure]];
                }
            } failureBlock:^(NSError *error) {
                [self dismissWithError:error];
            }];
        }
            break;
        case JXAssetPickerModeAlbumMedia: {
            NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
            if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]) {
                UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
                [self dismissWithImage:image asset:nil];
            }else if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
                NSURL *assetURL = (NSURL *)[info objectForKey:UIImagePickerControllerReferenceURL];
                ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
                [lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                                             scale:asset.defaultRepresentation.scale
                                                       orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
                        [self dismissWithImage:image asset:asset];
                    }else {
                        [self dismissWithError:[NSError jx_errorWithCode:JXErrorCodeActionFailure]];
                    }
                } failureBlock:^(NSError *error) {
                    [self dismissWithError:error];
                }];
            }
        }
            break;
        default:
            break;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
