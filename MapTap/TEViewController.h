//
//  TEViewController.h
//  MapTap
//
//  Created by Billy Rathje on 12/18/12.
//  Copyright (c) 2012 Billy Rathje. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TEDataModel.h"

@interface TEViewController : UIViewController <MKMapViewDelegate, NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// Model area
@property (strong) TEDataModel *theData;
@property (weak, nonatomic) IBOutlet UIView *adder;
@property (weak, nonatomic) IBOutlet UIView *transparentFrame;

// Text fields
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *comments;

// Server
@property (strong) NSURLConnection *modelsAnnotations;


// Actions
- (IBAction)returnPressed:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
