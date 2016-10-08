//
//  DCCacheManager.h
//  DiaCats
//
//  Created by Roman S on 07.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotosInfo.h"

@interface DCCacheManager : NSObject

+ (PhotosInfo *)cachedPhotosInfoForText:(NSString *)text;
+ (void)cachePhotosInfo:(PhotosInfo *)photosInfo forText:(NSString *)text;
+ (void)startNewSession;

@end
