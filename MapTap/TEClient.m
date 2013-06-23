//
//  TEClient.m
//  MapTap
//
//  Created by Billy Rathje on 6/17/13.
//  Copyright (c) 2013 Billy Rathje. All rights reserved.
//

#import "TEClient.h"

// URLs - can't tell whether to define or make vars.
//#define push_URL http://localhost:8000/maptap/push
//#define pull_URL http://localhost:8000/maptap/pull

@interface TEClient()

// XML Parser buffer
@property NSString *buffer;

@end

@implementation TEClient

// URLs
NSString *push_URL = @"http://localhost:8000/maptap/push/";
NSString *pull_URL = @"http://localhost:8000/maptap/pull/";


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
}

- (void) parse
{
    NSXMLParser *parse = [[NSXMLParser alloc] initWithContentsOfURL: [NSURL URLWithString: pull_URL]];
    parse.delegate = self;
    [parse parse];
    
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

@end
