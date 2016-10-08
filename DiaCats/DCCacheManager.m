//
//  DCCacheManager.m
//  DiaCats
//
//  Created by Roman S on 07.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCCacheManager.h"

@implementation DCCacheManager

+ (NSString *)cacheDirectory
{
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cacheDir = [cachesDir stringByAppendingPathComponent:@"DCCache"];
    NSLog(@"cacheDir = %@", cacheDir);
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:cacheDir] )
    {
        NSError *error;
        if ( ![[NSFileManager defaultManager] createDirectoryAtPath:cacheDir
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error] )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    return cacheDir;
}

+ (NSDictionary *)cacheDictionary
{
    NSString *cacheDirectory = [self cacheDirectory];
    NSString *pathToCacheDictionary = [cacheDirectory stringByAppendingPathComponent:@".plist"];
    NSDictionary *cacheDictionary = [NSDictionary dictionaryWithContentsOfFile:pathToCacheDictionary];
    
    if ( !cacheDictionary )
    {
        cacheDictionary = @{};
        if ( ![cacheDictionary writeToFile:pathToCacheDictionary atomically:YES] )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to create cache" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        };
    }
    
    return cacheDictionary;
}
    
+ (PhotosInfo *)cachedPhotosInfoForText:(NSString *)text
{
    NSString *fileName = [NSString stringWithFormat:@"CachedPhotosInfo_%@", text];
    NSString *pathToData = [[self cacheDirectory] stringByAppendingPathComponent:fileName];
    NSData *encodedData = [NSData dataWithContentsOfFile:pathToData];
    PhotosInfo *pInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];

    return pInfo;
};

+ (void)cachePhotosInfo:(PhotosInfo *)photosInfo forText:(NSString *)text
{
    NSString *fileName = [NSString stringWithFormat:@"CachedPhotosInfo_%@", text];
    NSString *pathToData = [[self cacheDirectory] stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:photosInfo toFile:pathToData];
};

@end
