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

NSString *push_URL = @"http://localhost:8000/maptap/push/";
NSString *pull_URL = @"http://localhost:8000/maptap/pull/";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView.delegate = self;
    [_mapView setShowsUserLocation: YES];
    [_mapView setMapType: MKMapTypeHybrid];
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
    
    [self sendHTTPMessageFromCurrentLocation: @"Well" withComment:@"Done"];
}

- (void) addAndUpdateAnnotations
{
/*
    while(1)
    {
        NSArray *temp = [[NSArray alloc] initWithArray: _theData.annotations];
        [_mapView removeAnnotations: temp];
        [_theData.annotations removeAllObjects];
        [self parse];
    
        // Deal with annotations
        NSArray *theAnnotations = [self makeAnnotationsList];
        [_mapView addAnnotations:theAnnotations];
        [_mapView showAnnotations: theAnnotations animated: YES];
        temp = nil;
        theAnnotations = nil;
        sleep(2);
    } */
}

- (void) parse
{
    // Start parsing
    NSURL *theUrl = [NSURL URLWithString: pull_URL];
    NSXMLParser *parse = [[NSXMLParser alloc] initWithContentsOfURL: theUrl];
    parse.delegate = self;
    [parse parse];
    NSLog(@"Done parsing");
    
}

- (void) sendHTTPMessageFromCurrentLocation: (NSString*) title withComment: (NSString*) comment
{

    title = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)(title), NULL, CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8));
    
    comment = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)(comment), NULL, CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8));
    
    NSString *bodyData = [NSString stringWithFormat: @"%@%f%@%f%@%@%@%@", @"latitude=", 1.0f, @"&longitude=", 1.0f, @"&title=", title, @"&comment=", comment];
    
    NSMutableURLRequest *postRequest =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString: push_URL]];
    
    // Set the request's content type to application/x-www-form-urlencoded
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:[bodyData length]]];
    // Initialize the NSURLConnection and proceed as usual
    [[NSURLConnection alloc] initWithRequest: postRequest delegate: self];
    NSLog(bodyData);
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName hasPrefix: @"object"])
    {
        [[_theData annotations] addObject: [[MKPointAnnotation alloc] init]];
    }
    
    if([elementName hasPrefix: @"field"])
    {
        if([[attributeDict valueForKey: @"name"] isEqualToString: @"comment"])
        {
            [[[_theData annotations] lastObject] setTitle: _buffer];
        }
        if([[attributeDict valueForKey: @"name"] isEqualToString: @"upVotes"])
        {
            [[[_theData annotations] lastObject] setSubtitle: _buffer];
        }
        if([[attributeDict valueForKey: @"name"] isEqualToString: @"longitude"])
        {
            [[[_theData annotations] lastObject] setCoordinate: CLLocationCoordinate2DMake(_buffer.integerValue, 0)];
        }
        if([[attributeDict valueForKey: @"name"] isEqualToString: @"title"])
        {
            MKPointAnnotation *temp = [[_theData annotations] lastObject];
            [[[_theData annotations] lastObject] setCoordinate: CLLocationCoordinate2DMake(temp.coordinate.latitude, _buffer.integerValue)];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    _buffer = string;
}


- (void) mapView:(MKMapView *) mapView didDeselectAnnotationView:(MKAnnotationView *) view
{
    if([view.annotation isEqual: _mapView.userLocation])
    {
        _adder.hidden = NO;
        _transparentFrame.hidden = NO;
        _mapView.userInteractionEnabled = NO;
    }
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


- (IBAction)returnPressed:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)done:(id)sender {
    [_location resignFirstResponder];
    [_comments resignFirstResponder];
    _adder.hidden = YES;
    _transparentFrame.hidden = YES;
    _mapView.userInteractionEnabled = YES;
}

- (IBAction)cancel:(id)sender {
    [_location resignFirstResponder];
    [_comments resignFirstResponder];
    _adder.hidden = YES;
    _transparentFrame.hidden = YES;
    _mapView.userInteractionEnabled = YES;
}
@end
