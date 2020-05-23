//
//  LKGoogleTranslator.h
//  GoogleTranslator
//

#import <Foundation/Foundation.h>
#import "LKConstants.h"

@interface LKGoogleTranslator : NSObject {

}

- (NSString*)translateText:(NSString*)sourceText fromLanguage:(NSString*)sourceLanguage toLanguage:(NSString*)targetLanguage;

@end
