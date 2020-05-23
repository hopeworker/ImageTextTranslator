//
//  ImageTextTranslatorAppDelegate.h
//  ImageTextTranslator
//
//  Created by xiongwei on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// conditionally import or forward declare to contain objective-c++ code to here.
#ifdef __cplusplus
#import "baseapi.h"
using namespace tesseract;
#else
@class TessBaseAPI;
#endif

#import "LKGoogleTranslator.h"

#define ENGLISH_LANG @"eng"
#define CHINESE_SIM_LANG @"chi_sim"

#define DEFAULT_OCR_LANGUAGE @"English"
#define DEFAULT_TRANSLATE_LANGUAGE @"ChineseSimplified"

@interface ImageTextTranslatorAppDelegate : UIResponder <UIApplicationDelegate>
{
    TessBaseAPI *tess;

}
@property (strong, nonatomic) UIWindow *window;
@property (copy, nonatomic) NSString *ocrLanguage;
@property (copy, nonatomic) NSString *ocrText;
@property (copy, nonatomic) NSString *fromLanguage;
@property (copy, nonatomic) NSString *toLanguage;

@property (retain, nonatomic) NSDictionary *ocrLanguageDic;
@property (retain, nonatomic) NSDictionary *translateLanguageDic;

@property (nonatomic, retain) LKGoogleTranslator *translator;	


-(void) tess_init;
-(void)languageSettingsInit;

- (NSString *)tess_OCR:(UIImage *)uiImage;
-(NSString *)translate:(NSString *)rawText;

-(void)resetOcrLanguage:(NSString *)inputKey;
-(void)resetTranslateLanguage:(NSString *)inputKey;

@end
