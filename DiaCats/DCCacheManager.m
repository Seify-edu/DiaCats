//
//  DCCacheManager.m
//  DiaCats
//
//  Created by Roman S on 07.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCCacheManager.h"

typedef NS_ENUM( int, CacheDirecrory )
{
    CacheDirectoryLast,
    CacheDirectoryCurrent,
};

@implementation DCCacheManager

+ (NSString *)pathToDirectory:(CacheDirecrory)dir
{
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cacheDir = [cachesDir stringByAppendingPathComponent:@"DCCache"];
    NSString *pathToDir = nil;
    switch ( dir )
    {
        case CacheDirectoryLast:
        {
            pathToDir = [cacheDir stringByAppendingPathComponent:@"LastSession"];
            break;
        }

        case CacheDirectoryCurrent:
        {
            pathToDir = [cacheDir stringByAppendingPathComponent:@"CurrentSession"];
            break;
        }

        default:
        {
            NSAssert( NO, @"Unxpected cache dir" );
            break;
        }
    }
    
    return pathToDir;
}

// creates directory if not exists
+ (NSString *)lastSessionCacheDir
{
    NSString *lastSessionCacheDir = [self pathToDirectory:CacheDirectoryLast];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:lastSessionCacheDir] )
    {
        NSError *error;
        if ( ![[NSFileManager defaultManager] createDirectoryAtPath:lastSessionCacheDir
                                        withIntermediateDirectories:YES
                                                         attributes:nil
                                                              error:&error] )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    return lastSessionCacheDir;
}

// creates directory if not exists
+ (NSString *)currentSessionCacheDir
{
    NSString *currentSessionCacheDir = [self pathToDirectory:CacheDirectoryCurrent];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:currentSessionCacheDir] )
    {
        NSError *error;
        if ( ![[NSFileManager defaultManager] createDirectoryAtPath:currentSessionCacheDir
                                        withIntermediateDirectories:YES
                                                         attributes:nil
                                                              error:&error] )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    return currentSessionCacheDir;
}

+ (void)startNewSession
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *pathToLastDir = [self pathToDirectory:CacheDirectoryLast];
    NSString *pathToCurrentDir = [self currentSessionCacheDir];
    
    if ([fileManager fileExistsAtPath:pathToLastDir])
    {
        NSError *error;
        [fileManager removeItemAtPath:pathToLastDir error:&error];
    }
    
    NSError *error2;
    [fileManager moveItemAtPath:pathToCurrentDir toPath:[self pathToDirectory:CacheDirectoryLast] error:&error2];
    if ( error2 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error2.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
};

+ (PhotosInfo *)cachedPhotosInfoForText:(NSString *)text
{
    for ( NSString *cacheDirectory in @[[self currentSessionCacheDir], [self lastSessionCacheDir]] )
    {
        NSString *fileName = [NSString stringWithFormat:@"CachedPhotosInfo_%@", text];
        NSString *pathToData = [cacheDirectory stringByAppendingPathComponent:fileName];
        NSData *encodedData = [NSData dataWithContentsOfFile:pathToData];
        PhotosInfo *pInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
        if ( pInfo ) return pInfo;
    }

    return nil;
};

+ (void)cachePhotosInfo:(PhotosInfo *)photosInfo forText:(NSString *)text
{
    NSString *fileName = [NSString stringWithFormat:@"CachedPhotosInfo_%@", text];
    NSString *pathToData = [[self currentSessionCacheDir] stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:photosInfo toFile:pathToData];
};

@end
