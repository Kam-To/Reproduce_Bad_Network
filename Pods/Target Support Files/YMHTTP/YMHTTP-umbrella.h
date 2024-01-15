#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSURLRequest+YMCategory.h"
#import "YMHTTP.h"
#import "YMURLSession.h"
#import "YMURLSessionConfiguration.h"
#import "YMURLSessionDelegate.h"
#import "YMURLSessionTask.h"

FOUNDATION_EXPORT double YMHTTPVersionNumber;
FOUNDATION_EXPORT const unsigned char YMHTTPVersionString[];

