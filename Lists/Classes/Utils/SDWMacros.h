//
//  SDWMacros.h
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//



/*** MISC ***/

#define CNIDegreesToRadians(degrees) (degrees * M_PI / 180)


/*** COLOR ***/

#define UIColorFromHEX(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0xFF)) / 255.0 alpha : 1.0]


/*** BLOCKS ***/

#define SDWPerformBlock(block, ...) { \
if (block) { \
block(__VA_ARGS__); \
} \
}

#define SDWPerformBlockOnMainThread(block, ...) { \
dispatch_async(dispatch_get_main_queue(), ^(void) { \
if (block) { \
block(__VA_ARGS__); \
} \
}); \
}

#define SDWPerformBlockOnMainThreadAfterDelay(delay, block, ...) { \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
if (block) { \
block(__VA_ARGS__); \
} \
}); \
}