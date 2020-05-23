//
//  ITT_ImagePickerController.m
//  ImageTextTranslator
//
//  Created by xiongwei on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ITT_ImagePickerViewController.h"
#import "baseapi.h"
#import "HTMLParser.h"
#import "UIImage+Resize.h"
#import "LKGoogleTranslator.h"

@interface ITT_ImagePickerViewController ()

@end

@implementation ITT_ImagePickerViewController
//@synthesize picker = _picker;
@synthesize soureType = _soureType;
@synthesize OCRTranslate_button = _OCRTranslate_button;
@synthesize focusButton = _focusButton;
//@synthesize ocrTextView = _ocrTextView;
//@synthesize translatedTextView = _translatedTextView;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize simpleImageEditorView = _simpleImageEditorView;
@synthesize appDelegate = _appDelegate;
- (void)dealloc 
{
    //[_picker release];
    //[_ocrTextView release];
    //[_translatedTextView release];
    [_simpleImageEditorView release];
    [_appDelegate release];
    [_OCRTranslate_button release];
    [_focusButton release];
    [_activityIndicatorView release];
    [super dealloc];
}


#pragma mark - init


//-(UIImagePickerController *)picker
//{
//    if (_picker != nil)
//    {
//        return _picker;
//    }
//    _picker = [[UIImagePickerController alloc] init];
//    return _picker;
//    
//}

-(AGSimpleImageEditorView *)simpleImageEditorView
{
    if (_simpleImageEditorView != nil)
    {
        return _simpleImageEditorView;
    }
    UIImage *initImage = [UIImage imageNamed:@"shadow.png"];
    
    _simpleImageEditorView = [[AGSimpleImageEditorView alloc] initWithImage:initImage];
    return _simpleImageEditorView;
}

-(void)initialSimpleImageEditorView:(UIImage *)image onView:(UIView *)outputView
{
    self.simpleImageEditorView.image = image;
    self.simpleImageEditorView.frame = outputView.frame;
    
    self.simpleImageEditorView.borderWidth = 1.f;
    self.simpleImageEditorView.borderColor = [UIColor darkGrayColor];
    self.simpleImageEditorView.ratioViewBorderColor = [UIColor orangeColor];
    self.simpleImageEditorView.ratioViewBorderWidth = 3.f;
    self.simpleImageEditorView.center = outputView.center;
    self.simpleImageEditorView.ratio =  4./3.;
    CGRect origCutRect = CGRectMake(100, 100, 100, 100);
    //CGRect origCutRect = outputView.frame;
   [self.simpleImageEditorView setCropRect:origCutRect];
}

#pragma mark - interface

-(void)setITT_imagePicker:(UIImagePickerControllerSourceType) pickerSourceType
{
    self.soureType = pickerSourceType;
}

#pragma mark - outlet action
- (IBAction)focusOnImage:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"focus"])
    {
        CGRect origCutRect = CGRectMake(100, 100, 100, 100);
        [self.simpleImageEditorView setCropRect:origCutRect];

        [sender setTitle:@"full screen" forState:UIControlStateNormal];
        
    }
    else if ([sender.titleLabel.text isEqualToString:@"full screen"])
    {
        CGRect origCutRect = self.view.frame;
        [self.simpleImageEditorView setCropRect:origCutRect];
        [sender setTitle:@"focus" forState:UIControlStateNormal];
    }
    else if([sender.titleLabel.text isEqualToString:@"mail"])
    {
        //[self.ocrTextView resignFirstResponder];
        //mail the text
        if(![MFMailComposeViewController canSendMail]) {
            // can't send mail.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Mail not configured or available." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setSubject:@"a message from micro bear"];
        
        // Fill out the email body text
        //NSString *sendText = [[NSString alloc] initWithFormat:@"image to text:\n\n%@\n translated text:\n\n%@", self.ocrTextView.text, self.translatedTextView.text];
        //NSString *sendText = [NSString stringWithFormat:@"image to text:\n\n%@\n translated text:\n\n%@", self.ocrTextView.text, self.translatedTextView.text];
        //[picker setMessageBody:sendText isHTML:NO];
        //[sendText release];
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }

}

-(void)ocr:(UIImage *)image
{
    //self.ocrTextView.text = [self.appDelegate tess_OCR:image];
    [self.activityIndicatorView stopAnimating];

}
-(void)translate:(NSString *)inputText
{
    //self.translatedTextView.text = [self.appDelegate translate:inputText];
    [self.activityIndicatorView stopAnimating];
    
}
- (IBAction)imageToText_translate:(UIButton *)sender
{
    [self.focusButton setTitle:@"mail" forState:UIControlStateNormal];
    //self.ocrTextView.hidden = NO;
    //self.translatedTextView.hidden = NO;

    if ([sender.titleLabel.text isEqualToString:@"image to text"])
    {
        [self.activityIndicatorView startAnimating];
        
        UIImage *selectedImage = [self.simpleImageEditorView output];
        //change the image to black and white image
        selectedImage = [self getGrayImage:selectedImage];
        
        [self performSelector:@selector(ocr:) withObject:selectedImage afterDelay:0.10];

        
        [self.simpleImageEditorView removeFromSuperview];

        [sender setTitle:@"translate" forState:UIControlStateNormal];


    }
    else if ([sender.titleLabel.text isEqualToString:@"translate"])
    {
        //[self.ocrTextView resignFirstResponder];
        [self.activityIndicatorView startAnimating];

        //[self performSelector:@selector(translate:) withObject:self.ocrTextView.text afterDelay:0.10];

    }
    else{}
}

- (IBAction)ocr_result:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"SEGUE_ocr" sender:self];

}

#pragma mark - UIViewController lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{

}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    //[self setOcrTextView:nil];
    //[self setTranslatedTextView:nil];
    [self setOCRTranslate_button:nil];
    [self setOCRTranslate_button:nil];
    [self setFocusButton:nil];
    [self setActivityIndicatorView:nil];
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
    // TODO: clean this up.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor blackColor];

    //self.ocrTextView.editable = NO;
    //self.translatedTextView.editable = NO;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:self.soureType];
    [picker setDelegate:self];
    
    // allowing editing is nice, but only returns a small 320px image
    picker.allowsEditing = YES; 
    [self presentModalViewController:picker animated:YES];
    [picker release];

}

- (void)viewDidUnload
{
    //[self setPicker:nil];
    //[self setOcrTextView:nil];
    //[self setTranslatedTextView:nil];
    [self setOCRTranslate_button:nil];
    [self setOCRTranslate_button:nil];
    [self setFocusButton:nil];
    [self setActivityIndicatorView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if([picker sourceType] == UIImagePickerControllerSourceTypeCamera)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera; 
    }
}

-(UIImage*)getGrayImage:(UIImage*)sourceImage 
{ 
    int width = sourceImage.size.width; 
    int height = sourceImage.size.height; 
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray(); 
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone); 
    CGColorSpaceRelease(colorSpace); 
    
    if (context == NULL) { 
        return nil; 
    } 
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage); 
    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:bwImage]; 
    CGImageRelease(bwImage);
    CGContextRelease(context); 
    
    return grayImage;
}
//-(UIImage *) imageTransBlackWhite:(UIImage *)inputImage
//{
//    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
//    CGContextRef context = CGBitmapContextCreate(nil, inputImage.size.width, inputImage.size.height, 8, inputImage.size.width, colorSapce, kCGImageAlphaNone);
//    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
//    CGContextSetShouldAntialias(context, NO);
//    CGContextDrawImage(context, CGRectMake(0, 0, inputImage.size.width, inputImage.size.height), [inputImage CGImage]);
//    
//    CGImageRef bwImage = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSapce);
//    
//    UIImage *resultImage = [UIImage imageWithCGImage:bwImage];
//    CGImageRelease(bwImage);
//    return resultImage;
//}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    //self.ocrTextView.hidden = YES;
    //self.translatedTextView.hidden = YES;
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    UIImage *origImage = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];    
    // save the image, only if it's a newly taken image:
    if([picker sourceType] == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(origImage, nil, nil, nil); 
    }
    
    CGRect rect;
    [[info objectForKey:UIImagePickerControllerCropRect] getValue:&rect];
    
    // fake resize to get the orientation right
    UIImage *croppedImage= [origImage resizedImage:origImage.size interpolationQuality:kCGInterpolationDefault];
    [origImage release];
    
    // crop, but maintain original size:
    croppedImage = [croppedImage croppedImage:rect];
    
    
    // resize, so as to not choke tesseract:
    // scaling up a low resolution image (eg. screenshots) seems to help the recognition.
    // 1200 pixels is an arbitrary value, but seems to work well.
    CGFloat newWidth = 1200; //(1000 < croppedImage.size.width) ? 1000 : croppedImage.size.width;
    CGSize newSize = CGSizeMake(newWidth,newWidth);
    
    croppedImage = [croppedImage resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
    //NSLog(@"resized image size: %@", [[NSValue valueWithCGSize:croppedImage.size] description]);
    
    [self initialSimpleImageEditorView:croppedImage onView:self.view];
    [self.view addSubview:self.simpleImageEditorView];
    [pool release];

}

#pragma mark MailComposer delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    NSString *message;
    message = nil;
    
    // Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
            //message = [NSString stringWithString:@"Mail Failed."];
            message = [[NSString alloc] initWithFormat:@"Mail Failed."];
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
    
    if(message != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status"
                                                        message:message delegate:nil 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [message release];
}

@end
