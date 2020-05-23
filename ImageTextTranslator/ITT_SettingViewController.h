//
//  ITT_SettingViewController.h
//  ImageTextTranslator
//
//  Created by xiongwei on 12-10-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageViewController.h"
#import "ImageTextTranslatorAppDelegate.h"

@interface ITT_SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, LanguageViewControllerProtocol>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) ImageTextTranslatorAppDelegate *appDelegate;

@end
