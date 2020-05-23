//
//  ImageTextTranslatorAppDelegate.m
//  ImageTextTranslator
//
//  Created by xiongwei on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageTextTranslatorAppDelegate.h"
#import "CheckNetwork.h"
@implementation ImageTextTranslatorAppDelegate

@synthesize window = _window;
@synthesize ocrLanguage = _ocrLanguage;
@synthesize ocrText = _ocrText;
@synthesize translator = _translator;
@synthesize fromLanguage = _fromLanguage;
@synthesize toLanguage = _toLanguage;
@synthesize ocrLanguageDic = _ocrLanguageDic;
@synthesize translateLanguageDic = _translateLanguageDic;

-(NSDictionary *)ocrLanguageDic
{
    if (_ocrLanguageDic == nil)
    {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *ocrLanguagefilePath = [bundlePath stringByAppendingPathComponent:@"ocrLanguagedic.plist"];

        _ocrLanguageDic = [[NSDictionary alloc] initWithContentsOfFile:ocrLanguagefilePath];
    }
    return _ocrLanguageDic;
}


-(NSDictionary *)translateLanguageDic
{
    if (_translateLanguageDic == nil)
    {
        _translateLanguageDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 //@"th",@"Thai",
                                 //@"af",@"Afrikaans",
                                 //@"sq",@"Albanian",
                                 @"ar",@"Arabic",
                                 //@"be",@"Belarusian",
                                 //@"bg",@"Bulgarian",
                                 //@"ca",@"Catalan",
                                 //@"zh",@"Chinese",
                                 @"zh-cn",DEFAULT_TRANSLATE_LANGUAGE,
                                 @"zh-tw",@"ChineseTraditional",
                                 //@"hr",@"Croatian",
                                 //@"cs",@"Czech",
                                 //@"da",@"Danish",
                                 //@"nl",@"Dutch",
                                 @"en",DEFAULT_OCR_LANGUAGE,
                                 //@"et",@"Estonian",
                                 //@"tl",@"Filipino",
                                 //@"fi",@"Finnish",
                                 @"fr",@"French",
                                 //@"gl",@"Galician",
                                 @"de",@"German",
                                 //@"el",@"Greek",
                                 //@"iw",@"Hebrew",
                                 //@"hi",@"Hindi",
                                 //@"hu",@"Hungarian",
                                 //@"is",@"Icelandic",
                                 //@"id",@"Indonesian",
                                 //@"ga",@"Irish",
                                 @"it",@"Italian",
                                 @"ja",@"Japanese",
                                 @"ko",@"Korean",
                                 //@"lv",@"Latvian",
                                 //@"lt",@"Lithuanian",
                                 //@"mk",@"Macedonian",
                                 //@"ms",@"Malay",
                                 //@"mt",@"Maltese",
                                 //@"no",@"Norwegian",
                                 //@"fa",@"Persian",
                                 //@"pl",@"Polish",
                                 //@"pt",@"Portuguese",
                                 //@"ro",@"Romanian",
                                 @"ru",@"Russian",
                                 //@"sr",@"Serbian",
                                 //@"sk",@"Slovak",
                                 //@"sl",@"Slovenian",
                                 @"es",@"Spanish",
                                 //@"sw",@"Swahili",
                                 //@"sv",@"Swedish",
                                 //@"tr",@"Turkish",
                                 //@"uk",@"Ukrainian",
                                 //@"vi",@"Vietnamese",
                                 //@"cy",@"Welsh",
                                 //@"yi",@"Yiddish", 
                                 nil];
 
    }

    return _translateLanguageDic;
}

- (void)dealloc
{
    tess->End(); // shutdown tesseract
    delete tess;
    [_ocrLanguage release];
    [_ocrText release];
    [_translator release];
    [_fromLanguage release];
    [_toLanguage release];
    [_ocrLanguageDic release];
    [_translateLanguageDic release];
    [_window release];
    [super dealloc];
}

#pragma mark - language set

-(void)resetOcrLanguage:(NSString *)inputKey
{
    self.ocrLanguage = [self.ocrLanguageDic objectForKey:inputKey];
    self.fromLanguage = [self.translateLanguageDic objectForKey:inputKey];
}
-(void)resetTranslateLanguage:(NSString *)inputKey
{
    self.toLanguage = [self.translateLanguageDic objectForKey:inputKey];
}
#pragma mark - init

-(LKGoogleTranslator *)translator
{
    if (_translator == nil)
    {
        _translator = [[LKGoogleTranslator alloc] init];
        //self.fromLanguage = LKLanguageEnglish;
        //self.toLanguage = LKLanguageChineseSimplified;
    }
    return _translator;
}

-(void)setOcrLanguage:(NSString *)ocrLanguage
{
    if (_ocrLanguage == nil)
    {
        _ocrLanguage = ENGLISH_LANG;
    }
    else if ([_ocrLanguage isEqualToString:ocrLanguage])
    {
    }
    else
    {
        [_ocrLanguage release];
        _ocrLanguage = [ocrLanguage copy];
        NSString *dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"tessdata"];
        tess->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding],    // Path to tessdata-no ending /.
                   [self.ocrLanguage cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    return;
}

-(void)languageSettingsInit
{
    //restore previous settings
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"OCR_LANGUAGE"])
    { 
        [[NSUserDefaults standardUserDefaults] setObject:DEFAULT_OCR_LANGUAGE forKey:@"OCR_LANGUAGE"]; 
        
    }
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"TRANSLATE_LANGUAGE"])
    { 
        [[NSUserDefaults standardUserDefaults] setObject:DEFAULT_TRANSLATE_LANGUAGE forKey:@"TRANSLATE_LANGUAGE"]; 
        
    }
    [self resetOcrLanguage:[[NSUserDefaults standardUserDefaults] stringForKey:@"OCR_LANGUAGE"]];
    [self resetTranslateLanguage:[[NSUserDefaults standardUserDefaults] stringForKey:@"TRANSLATE_LANGUAGE"]];
}
#pragma mark Application's documents directory
/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark - tess

-(void) tess_init
{
    if (tess == nil) 
    {
        // Set up the tessdata path. This is included in the application bundle
        // but is copied to the Documents directory on the first run.
        NSString *dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"tessdata"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // If the expected store doesn't exist, copy the default store.
        if (![fileManager fileExistsAtPath:dataPath]) {
            // get the path to the app bundle (with the tessdata dir)
            NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
            NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata-svn"];
            if (tessdataPath) {
                [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
            }
        }
        
        NSString *dataPathWithSlash = [[self applicationDocumentsDirectory] stringByAppendingString:@"/"];
        setenv("TESSDATA_PREFIX", [dataPathWithSlash UTF8String], 1);
        
        // init the tesseract engine.
        tess = new TessBaseAPI();
        self.ocrLanguage = ENGLISH_LANG;
        tess->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding],    // Path to tessdata-no ending /.
                   [self.ocrLanguage cStringUsingEncoding:NSUTF8StringEncoding]);
        tess->SetPageSegMode(PSM_SINGLE_BLOCK);
    }

}

- (NSString *)tess_OCR:(UIImage *)uiImage 
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    CGSize imageSize = [uiImage size];
    //NSLog(@"%f, %f", imageSize.width, imageSize.height);
    int bytes_per_line  = (int)CGImageGetBytesPerRow([uiImage CGImage]);
    int bytes_per_pixel = (int)CGImageGetBitsPerPixel([uiImage CGImage]) / 8.0;
    
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider([uiImage CGImage]));
    const UInt8 *imageData = CFDataGetBytePtr(data);
    
    // this could take a while.
    char* text = tess->TesseractRect(imageData,
                                     bytes_per_pixel,
                                     bytes_per_line,
                                     0, 0,
                                     imageSize.width, imageSize.height);
    
    //NSLog(@"%@", [NSString stringWithCString:text encoding:NSUTF8StringEncoding]);
    self.ocrText = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    
    delete[] text;
    CFRelease(data);
    [pool release];
    
    return self.ocrText;
}


#pragma mark - translate
-(NSString *)translate:(NSString *)rawText
{
    NSString *translatedText = [NSString string];
    if (![CheckNetwork isExistenceNetwork])
    {
        return translatedText;
    }
    //NSLog(@"%@, %@", self.fromLanguage, self.toLanguage);
    translatedText = [self.translator translateText: rawText
                                            fromLanguage: self.fromLanguage
                                              toLanguage: self.toLanguage];
    return translatedText;
}


#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self tess_init];
    [self languageSettingsInit];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
