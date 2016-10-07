//
//  MapViewController.h
//  DiaCats
//
//  Created by Roman S on 07.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@interface PhotoAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImage *image;
@end

@interface MapPhotoInfo : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@end

@interface MapViewController : UIViewController

@property (weak) IBOutlet MKMapView *mapView;
- (instancetype)initWithPhotosInfo:(NSArray *)photosInfo;

@end
