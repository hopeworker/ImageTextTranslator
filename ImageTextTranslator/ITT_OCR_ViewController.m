//
//  ITT_OCR_ViewController.m
//  ImageTextTranslator
//
//  Created by xiongwei on 15-9-5.
//
//

#import "ITT_OCR_ViewController.h"

@interface ITT_OCR_ViewController ()

@end

@implementation ITT_OCR_ViewController
@synthesize ocrTextView = _ocrTextView;
@synthesize translatedTextView = _translatedTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)back_home:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"SEGUE_backhome" sender:self];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.translatedTextView.text = @"sample text!";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation



@end
