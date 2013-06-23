//
//  TEViewController.m
//  MapTap
//
//  Created by Billy Rathje on 12/18/12.
//  Copyright (c) 2012 Billy Rathje. All rights reserved.
//

#import "TEViewController.h"

@interface TEViewController ()

@property NSString *buffer;


@end

@implementation TEViewController

- (id) init
{
    if(self = [super init])
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _HTTPClient = [[TEClient alloc] init];
    _mapView.delegate = self;
    [_mapView setShowsUserLocation: YES];
    [_mapView setMapType: MKMapTypeHybrid];
    _container.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
    [_mapView setRegion:region animated:YES];
    
    
    // Initialize data model
    _theData = [[TEDataModel alloc] init];
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(addAndUpdateAnnotations)
                                                   object:nil];
    [myThread start];  // Actually create the thread
    
    [_HTTPClient sendHTTPMessageFromCurrentLocation: @"Well" withComment:@"Done"];
}

- (void) addAndUpdateAnnotations
{
/*
    while(1)
    {
        NSArray *temp = [[NSArray alloc] initWithArray: _theData.annotations];
        [_mapView removeAnnotations: temp];
        [_theData.annotations removeAllObjects];
        [_HTTPClient parse];
    
        // Deal with annotations
        NSArray *theAnnotations = [self makeAnnotationsList];
        [_mapView addAnnotations:theAnnotations];
        [_mapView showAnnotations: theAnnotations animated: YES];
        temp = nil;
        theAnnotations = nil;
        sleep(2);
    } */
} 

- (NSArray *) makeAnnotationsList
{
    _mapView.userLocation.title = @"Here.";
    _mapView.userLocation.subtitle = @"Your current location.";
    MKPointAnnotation *userLoc = [[MKPointAnnotation alloc] init];
    userLoc.title = _mapView.userLocation.title;
    userLoc.subtitle = _mapView.userLocation.subtitle;
    userLoc.coordinate = _mapView.userLocation.coordinate;
    
    //[theData.annotations addObject: userLoc];

    /*
    
    for(int i = 1; i < 500; i++)
    {
        MKPointAnnotation *foo = [[MKPointAnnotation alloc] init];
        MKPointAnnotation *bar = [[MKPointAnnotation alloc] init];
        
        foo.title = @"Hi";
        bar.title = @"Hi";
        foo.subtitle = @"Yeah.";
        bar.subtitle = @"Yeah.";
        
        foo.coordinate = CLLocationCoordinate2DMake(userLoc.coordinate.latitude + .005*i , userLoc.coordinate.longitude + .005*i);
        bar.coordinate = CLLocationCoordinate2DMake(userLoc.coordinate.latitude + .005*i , userLoc.coordinate.longitude - .005*i);
        
        [theData.annotations addObject: foo];
        [theData.annotations addObject: bar];
    } */
    
    // Anything over 1000 may not work
    return _theData.annotations;
}


- (IBAction)returnPressed:(id)sender
{
    [sender resignFirstResponder];
}


- (IBAction)okPressed:(UIButton *)sender
{
    [_location resignFirstResponder];
    [_comments resignFirstResponder];
    _container.hidden = YES;
    _mapView.userInteractionEnabled = YES;
}

- (IBAction)cancelPressed:(UIButton *)sender
{
    [_location resignFirstResponder];
    [_comments resignFirstResponder];
    _container.hidden = YES;
    _mapView.userInteractionEnabled = YES;
}

- (IBAction)longPress:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"HERE");
    _mapView.userInteractionEnabled = NO;
    [_container setCenter: [sender locationInView:self.mapView]];
    _container.hidden = NO;

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    CLLocationCoordinate2D coord = [self.mapView convertPoint:[sender locationInView: self.mapView] toCoordinateFromView: self.mapView];

    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
        }
        NSLog(@"Received placemarks: %@", placemarks);
        _location.text = [placemarks[0] description];
    }];
}

@end
