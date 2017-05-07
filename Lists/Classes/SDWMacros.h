//
//  SDWMacros.h
//  Lists
//
//  Created by Alex Linkov on 5/5/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

/********* Block *********/

#define SDWPerformBlock(block, ...) { \
if (block) { \
block(__VA_ARGS__); \
} \
}

#define SDWPerformBlockOnMainThread(block, ...) { \
if([NSThread isMainThread]){\
if (block) { \
block(__VA_ARGS__); \
} \
}\
else{\
dispatch_async(dispatch_get_main_queue(), ^(void) { \
if (block) { \
block(__VA_ARGS__); \
} \
}); \
}\
}

#define SDWPerformBlockOnMainThreadAfterDelay(delay, block, ...) { \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
if (block) { \
block(__VA_ARGS__); \
} \
}); \
}

/********* Equation *********/

#define SDWFEQUAL(a, b) (fabs((a) - (b)) < FLT_EPSILON)
#define SDWFEQUALZERO(a) (fabs(a) < FLT_EPSILON)

/********* Color *********/

#define SDWUIColorFromRGB(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]

#define SDWUIColorFromHEX(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]

/********* String *********/

#define SDWLocalizedString(key) NSLocalizedString(key, nil)

/********* Timer *********/

#define SDWInvalidateTimer(t) [t invalidate]; t = nil;

/********* Device *********/

#define SDW_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SDW_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SDW_IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SDW_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SDW_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SDW_SCREEN_MAX_LENGTH (MAX(SDW_SCREEN_WIDTH, SDW_SCREEN_HEIGHT))
#define SDW_SCREEN_MIN_LENGTH (MIN(SDW_SCREEN_WIDTH, SDW_SCREEN_HEIGHT))

#define SDW_IS_IPHONE_4_OR_LESS (SDW_IS_IPHONE && SDW_SCREEN_MAX_LENGTH < 568.0)
#define SDW_IS_IPHONE_5 (SDW_IS_IPHONE && SDW_SCREEN_MAX_LENGTH == 568.0)
#define SDW_IS_IPHONE_6 (SDW_IS_IPHONE && SDW_SCREEN_MAX_LENGTH == 667.0)
#define SDW_IS_IPHONE_6P (SDW_IS_IPHONE && SDW_SCREEN_MAX_LENGTH == 736.0)

/********* Language *********/

#define SDWNonnull(x) (id __nonnull)x
