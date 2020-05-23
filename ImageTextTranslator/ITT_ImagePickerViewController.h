//
//  ITT_ImagePickerController.h
//  ImageTextTranslator
//
//  Created by xiongwei on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// conditionally import or forward declare to contain objective-c++ code to here.
#import <MessageUI/MessageUI.h>

#import "ZoomableImage.h"
#import "CheckNetwork.h"
// conditionally import or forward declare to contain objective-c++ code to here.
#ifdef __cplusplus
#import "baseapi.h"
using namespace tesseract;
#else
@class TessBaseAPI;
#endif
#import "AGSimpleImageEditorView.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageTextTranslatorAppDelegate.h"

@interface ITT_ImagePickerViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>

//@property (nonatomic, retain) UIImagePickerController *picker;
@property (nonatomic, assign) UIImagePickerControllerSourceType soureType;
@property (retain, nonatomic) IBOutlet UIButton *OCRTranslate_button;
@property (retain, nonatomic) IBOutlet UIButton *focusButton;
//@property (retain, nonatomic) IBOutlet UITextView *ocrTextView;
//@property (retain, nonatomic) IBOutlet UITextView *translatedTextView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic, retain) AGSimpleImageEditorView *simpleImageEditorView;
@property (nonatomic, retain) ImageTextTranslatorAppDelegate *appDelegate;

-(void)setITT_imagePicker:(UIImagePickerControllerSourceType) pickerSourceType;
@end
