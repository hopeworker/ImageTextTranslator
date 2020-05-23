//
//  LKGoogleTranslator.m
//  GoogleTranslator
//

#import "LKGoogleTranslator.h"
#import "HTMLParser.h"

#define TEXT_VAR @"&text="
#define URL_STRING @"http://translate.google.cn/?langpair="

@implementation LKGoogleTranslator


-(NSStringEncoding) getLanguageNSStringEncoding:(NSString *)targetLanguage ocrLanguage:(NSString *)sourceLanguage
{
    NSStringEncoding enc = kCFStringEncodingGB_18030_2000;
    //change with the translated language
    if ([sourceLanguage isEqualToString:@"en"])
    {
        if ([targetLanguage isEqualToString:@"ja"])
        {
            enc = NSShiftJISStringEncoding;
        }
        else if ([targetLanguage isEqualToString:@"zh-tw"])
        {
            enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingBig5);
        }
        else if ([targetLanguage isEqualToString:@"ru"])
        {
            enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingKOI8_R);
        }
        else if ([targetLanguage isEqualToString:@"ko"])
        {
            enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingEUC_KR);
        }
        else if ([targetLanguage isEqualToString:@"ar"])
        {
            enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingISOLatinArabic);
        }
        else
        {
            enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        }
    }
    else if ([sourceLanguage isEqualToString:@"zh-cn"])
    {
        enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    }
    else{}
    
    return enc;
}
- (NSString*)translateText:(NSString*)sourceText fromLanguage:(NSString*)sourceLanguage toLanguage:(NSString*)targetLanguage
{
	NSMutableString* urlString = [NSMutableString string];
	[urlString appendString: URL_STRING];
	[urlString appendString: sourceLanguage];
	[urlString appendString: @"%7C"];
	[urlString appendString: targetLanguage];
	[urlString appendString: TEXT_VAR];
	[urlString appendString: [sourceText stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
	NSURL* url = [NSURL URLWithString: urlString];
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40.0];
	NSError* error;
    NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil
                                                       error:&error];

    
    NSString *translatedText = [NSString string];
    /* 下载的数据 */
    if (data != nil)
    {
     
            

        //编码转换 gb2313 to UTF
        NSStringEncoding enc = [self getLanguageNSStringEncoding:targetLanguage ocrLanguage:sourceLanguage];
        NSString * myResponseStr = [[NSString alloc] initWithData:data encoding:enc];
        //parse html head to get the right charset
        //NSString *charset = [self htmlParserCharset:myResponseStr];

        //recreate the string with the right encoding
        //myResponseStr = [[NSString alloc] initWithData:data encoding:enc];

        //NSLog(@"%@", myResponseStr);
        //xw test
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"download.html"];    
//        [data writeToFile:filePath atomically:YES];
        
        //NSLog(@"%@", myResponseStr);
        translatedText = [self htmlParser:myResponseStr inputText:sourceText];
        //translatedText = [self htmlDataParser:data inputText:sourceText];

        [myResponseStr release];
        
    } 
    else
    {
        NSLog(@"%@", error);
    }
    return translatedText;
    
}
-(NSString *)htmlParserCharset:(NSString *)html
{
    NSString *outText = [NSString string];
    NSError* error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        [parser release];
        return outText;
    }
    
    HTMLNode *bodyNode = [parser head];
    
    NSArray *spanNodes = [bodyNode findChildTags:@"meta"];
    
    
    for (HTMLNode *spanNode in spanNodes)
    {
        NSString *metaContent = [spanNode getAttributeNamed:@"content"];
        NSRange findRange;
        findRange = [metaContent rangeOfString:@"charset"];
        if (findRange.length != 0)
        {
            outText = [metaContent substringFromIndex:(findRange.location + 8)];
        }
    }
    [parser release];
    return outText;
}

-(NSString *)htmlDataParser:(NSData *)html_data inputText:(NSString *)inputText
{
    NSString *outText = [NSString string];
    NSError* error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithData:html_data error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        [parser release];
        return outText;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    
    NSArray *spanNodes = [bodyNode findChildTags:@"span"];
    NSArray *inputLineText = [inputText componentsSeparatedByString:@"\n"];
    
    
    for (HTMLNode *spanNode in spanNodes)
    {

        for (NSString *curLineText in inputLineText)
        {
            NSCharacterSet *trimSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
            NSString *trimedCurLineText = [curLineText stringByTrimmingCharactersInSet:trimSet];
            if ([[spanNode getAttributeNamed:@"title"] isEqualToString:trimedCurLineText])
            {
                outText = [outText stringByAppendingFormat:@"\n%@", [spanNode contents]];
                
            }
        }
        
    }
    
    [parser release];
    return outText;
}

-(NSString *)htmlParser:(NSString *)html inputText:(NSString *)inputText
{
    NSString *outText = [NSString string];
    NSError* error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        [parser release];
        return outText;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *spanNodes = [bodyNode findChildTags:@"span"];
    NSArray *inputLineText = [inputText componentsSeparatedByString:@"\n"];

    
    for (HTMLNode *spanNode in spanNodes)
    {
        for (NSString *curLineText in inputLineText)
        {
            NSCharacterSet *trimSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
            NSString *trimedCurLineText = [curLineText stringByTrimmingCharactersInSet:trimSet];
            if ([[spanNode getAttributeNamed:@"title"] isEqualToString:trimedCurLineText])
            {
                outText = [outText stringByAppendingFormat:@"\n%@", [spanNode contents]];
                
            }
        }

    }
    
    [parser release];
    return outText;
}

@end
