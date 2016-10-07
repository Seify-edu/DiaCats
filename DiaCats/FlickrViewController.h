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
@property (nonatomic, weak) IBOutlet UIButton *authButton;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
- (IBAction)authPressed;
- (IBAction)searchPressed;

@end
