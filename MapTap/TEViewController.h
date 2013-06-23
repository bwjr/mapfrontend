//
//  TEViewController.h
//  MapTap
//
//  Created by Billy Rathje on 12/18/12.
//  Copyright (c) 2012 Billy Rathje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TEDataModel.h"
#import "TEClient.h"

@interface TEViewController : UIViewController <MKMapViewDelegate, NSXMLParserDelegate, NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// View container
@property (weak, nonatomic) IBOutlet UIView *container;

// Text fields
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextView *comments;

// Actions
- (IBAction)okPressed:(UIButton *)sender;
- (IBAction)cancelPressed:(UIButton *)sender;
- (IBAction)longPress:(UILongPressGestureRecognizer *)sender;

// Server
@property (strong) TEClient *HTTPClient;

// Model area
@property (strong, nonatomic) TEDataModel *theData;

@end
