//
//  FlickrViewController.h
//  DiaCats
//
//  Created by Roman S on 07.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *authLabel;
@property IBOutlet UIButton *authButton;
- (IBAction)authPressed;

@end
