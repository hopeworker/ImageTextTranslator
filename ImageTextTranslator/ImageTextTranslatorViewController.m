//
//  ImageTextTranslatorViewController.m
//  ImageTextTranslator
//
//  Created by xiongwei on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageTextTranslatorViewController.h"
#import "ITT_ImagePickerViewController.h"

#define SEGUE_CAMERASTART @"SEGUE_cameraStart"


@interface ImageTextTranslatorViewController ()
@property (nonatomic, assign) UIImagePickerControllerSourceType soureType;

@end



@implementation ImageTextTranslatorViewController
@synthesize soureType = _soureType;


#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - outlet process


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0)
    {
        //NSLog(@"Button 0 pressed");
        self.soureType =  UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1)
    {
        //NSLog(@"Button 1 pressed");
        self.soureType =  UIImagePickerControllerSourceTypePhotoLibrary;

    }
    else
    {
        return;
    }
    [self performSegueWithIdentifier:SEGUE_CAMERASTART sender:self];

}


- (IBAction)cameraStart:(UIButton *)sender
{

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        //    if(1)  // for testing the alert sheet only
    {
        // this device has a camera, display the alert sheet:
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Select Image Source"
                                      delegate:self 
                                      cancelButtonTitle:@"Cancel" 
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Camera",@"Photo Library", nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
        // the tab bar was interferring in the current view
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]]; 
        [actionSheet release];
    }
    else
    {
        // without a camera, there is no choice to make. just display the modal image picker
        //[self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
        //UIImage *croppedImage = [UIImage imageNamed:@"IMG_0004.jpg"];
        //[self performSelector:@selector(threadedReadAndProcessImage:) withObject:croppedImage afterDelay:0.10];
        //[self simulate_threadedReadAndProcessImage];
        self.soureType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self performSegueWithIdentifier:SEGUE_CAMERASTART sender:self];

    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"segue's identifier == %@", segue.identifier);
    if ([segue.destinationViewController isKindOfClass:[ITT_ImagePickerViewController class]])
    {
        //NSLog(@"%d", self.soureType);
        [segue.destinationViewController setITT_imagePicker:self.soureType];

    }

}
@end
