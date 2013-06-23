//
//  TEClient.h
//  MapTap
//
//  Created by Billy Rathje on 6/17/13.
//  Copyright (c) 2013 Billy Rathje. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "TEDataModel.h"

@interface TEClient : NSObject <NSXMLParserDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) TEDataModel *theData;

- (void) sendHTTPMessageFromCurrentLocation: (NSString *) title withComment: (NSString *) comment;
- (void) parse;

@end
