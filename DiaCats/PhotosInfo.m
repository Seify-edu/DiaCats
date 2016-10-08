//
//  PhotosInfo.m
//  DiaCats
//
//  Created by Roman S on 08.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import "PhotosInfo.h"
#import "FlickrKit.h"

@implementation MapPhotoInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super init] )
    {
        self.url        = [aDecoder decodeObjectForKey:@"url"];
        self.longitude  = [aDecoder decodeObjectForKey:@"longitude"];
        self.latitude   = [aDecoder decodeObjectForKey:@"latitude"];
    }
    
    return self;
}
@end

@implementation PhotosInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.info forKey:@"info"];
};

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super init] )
    {
        self.info = [aDecoder decodeObjectForKey:@"info"];
    }
    
    return self;
};

- (instancetype)initWithFlickrResponse:(NSDictionary *)response
{
    if ( self = [super init] )
    {
        NSMutableArray *mInfo = [NSMutableArray array];
        
        for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"])
        {
            MapPhotoInfo *info = [[MapPhotoInfo alloc] init];
            info.url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
            info.longitude = photoDictionary[@"longitude"];
            info.latitude = photoDictionary[@"latitude"];
            [mInfo addObject:info];
        }
        
        self.info = [mInfo copy];
    }
    
    return self;
};

@end
