//
//  LanguageViewController.h
//  ImageTextTranslator
//
//  Created by xiongwei on 12-10-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LanguageViewControllerProtocol
- (void) languageSelectionUpdate:(NSString*)selectedLanguage;
- (NSString*) getDefaultLanguage;
-(void) saveSelectedLanguage;

@end

@interface LanguageViewController : UITableViewController

@property (nonatomic, assign) id<LanguageViewControllerProtocol> delegate;

-(void) setLanguageList:(NSArray *)languageList;
@end
