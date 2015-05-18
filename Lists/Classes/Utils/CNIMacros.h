//
//  CNIMacros.h
//  ios-merchant
//
//  Created by Anton Domashnev on 4/27/15.
//  Copyright (c) 2015 Conichi. All rights reserved.
//

@import Foundation;

/*** MISC ***/

#define CNIDegreesToRadians(degrees) (degrees * M_PI / 180)

/*** COLOR ***/

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]

#define UIColorFromHEX(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]

/*** FONTS ***/

#define UIFontGothamNarrowBook(fontSize) [UIFont fontWithName : @"GothamNarrow-Book" size : fontSize]
#define UIFontGothamBook(fontSize) [UIFont fontWithName : @"Gotham-Book" size : fontSize]
#define UIFontGothamLight(fontSize) [UIFont fontWithName : @"Gotham-Light" size : fontSize]
#define UIFontGothamExtraLight(fontSize) [UIFont fontWithName : @"Gotham-ExtraLight" size : fontSize]
#define UIFontGothamBook(fontSize) [UIFont fontWithName : @"Gotham-Book" size : fontSize]
#define UIFontGothamMedium(fontSize) [UIFont fontWithName : @"Gotham-Medium" size : fontSize]
#define UIFontOpenSansLight(fontSize) [UIFont fontWithName : @"OpenSans-Light" size : fontSize]
#define UIFontOpenSans(fontSize) [UIFont fontWithName : @"OpenSans" size : fontSize]
#define UIFontOpenSansSemibold(fontSize) [UIFont fontWithName : @"OpenSans-Semibold" size : fontSize]

/*** BLOCKS ***/

#define CNIPerformBlock(block, ...) { \
        if (block) { \
            block(__VA_ARGS__); \
        } \
}

#define CNIPerformBlockOnMainThread(block, ...) { \
        dispatch_async(dispatch_get_main_queue(), ^(void) { \
            if (block) { \
                block(__VA_ARGS__); \
            } \
        }); \
}

#define CNIPerformBlockOnMainThreadAfterDelay(delay, block, ...) { \
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
            if (block) { \
                block(__VA_ARGS__); \
            } \
        }); \
}