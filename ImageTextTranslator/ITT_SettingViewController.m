//
//  ITT_SettingViewController.m
//  ImageTextTranslator
//
//  Created by xiongwei on 12-10-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ITT_SettingViewController.h"

@interface ITT_SettingViewController ()

@property (nonatomic, copy) NSString* ocrLanguage;
@property (nonatomic, copy) NSString* translateLanguage;
@property (nonatomic, retain) NSArray* ocrLanguageList;
@property (nonatomic, retain) NSArray* translateLanguageList;

@property NSUInteger curSection;

@end

@implementation ITT_SettingViewController
@synthesize tableView;
@synthesize ocrLanguage = _ocrLanguage;
@synthesize translateLanguage = _translateLanguage;
@synthesize ocrLanguageList = _ocrLanguageList;
@synthesize translateLanguageList = _translateLanguageList;
@synthesize appDelegate = _appDelegate;
@synthesize curSection;

//-(NSMutableArray *)ocrLanguageList
//{
//    if (_ocrLanguageList == nil)
//    {
//        _ocrLanguageList = [[NSMutableArray alloc] initWithObjects:@"English",@"Chinese", nil];
//    }
//    return _ocrLanguageList;
//}
//
//-(NSMutableArray *)translateLanguageList
//{
//    if (_translateLanguageList == nil)
//    {
//        _translateLanguageList = [[NSMutableArray alloc] initWithObjects:@"English",@"Chinese",@"French", nil];
//    }
//    return _translateLanguageList;
//}


- (void)dealloc {
    [tableView release];
    [_ocrLanguage release];
    [_translateLanguage release];
    [super dealloc];
}


#pragma mark - LanguageViewControllerProtocol

- (void) languageSelectionUpdate:(NSString*)selectedLanguage
{
    if (curSection == 0)
    {
        self.ocrLanguage = selectedLanguage;
    }
    else 
    {
        self.translateLanguage = selectedLanguage;
    }
    [self.tableView reloadData];
}

- (NSString*) getDefaultLanguage
{
    if (curSection == 0)
    {
        return self.ocrLanguage;
    }
    else 
    {
        return self.translateLanguage;
    }
}

-(void) saveSelectedLanguage
{
    [[NSUserDefaults standardUserDefaults] setObject:self.ocrLanguage forKey:@"OCR_LANGUAGE"];
    [[NSUserDefaults standardUserDefaults] setObject:self.translateLanguage forKey:@"TRANSLATE_LANGUAGE"];
    
    [self.appDelegate resetOcrLanguage:self.ocrLanguage];
    [self.appDelegate resetTranslateLanguage:self.translateLanguage];
}
#pragma mark - UIViewController delegate


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.ocrLanguageList = [self.appDelegate.ocrLanguageDic allKeys];
    self.translateLanguageList = [[self.appDelegate.translateLanguageDic allKeys] sortedArrayUsingSelector:  
                 @selector(compare:)]; 

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    

    self.ocrLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"OCR_LANGUAGE"];
    self.translateLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"TRANSLATE_LANGUAGE"];
    [self.appDelegate resetOcrLanguage:self.ocrLanguage];
    [self.appDelegate resetTranslateLanguage:self.translateLanguage];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated
{

}


- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"image to text language";
    }
    else
    {
        return @"translate language";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)xw_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"language_cell";
    UITableViewCell *cell = [xw_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = self.ocrLanguage;
    }
    else
    {
        cell.textLabel.text = self.translateLanguage;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
#define SEGUE_LANGUAGE @"SEGUE_language"

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    curSection = indexPath.section;
    [self performSegueWithIdentifier:SEGUE_LANGUAGE sender:self];

}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"segue's identifier == %@", segue.identifier);
    if ([segue.destinationViewController isKindOfClass:[LanguageViewController class]])
    {    
        if (curSection == 0)
        {
            [segue.destinationViewController setLanguageList:self.ocrLanguageList];
            [segue.destinationViewController setTitle:@"image to text language"];
        }
        else 
        {
            [segue.destinationViewController setLanguageList:self.translateLanguageList];
            [segue.destinationViewController setTitle:@"translate language"];

        }
        [segue.destinationViewController setDelegate:self];

    }

}


@end
