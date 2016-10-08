//
//  PhotosInfo.h
//  DiaCats
//
//  Created by Roman S on 08.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapPhotoInfo : NSObject <NSCoding>
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@end

@interface PhotosInfo : NSObject <NSCoding>
- (instancetype)initWithFlickrResponse:(NSDictionary *)response;
@property (strong) NSArray *info;
@end
