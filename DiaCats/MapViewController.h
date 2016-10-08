//
//  MapViewController.h
//  DiaCats
//
//  Created by Roman S on 07.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "PhotosInfo.h"

@interface PhotoAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImage *image;
@end

@interface MapViewController : UIViewController

@property (weak) IBOutlet MKMapView *mapView;
- (instancetype)initWithPhotosInfo:(PhotosInfo *)photosInfo;

@end
