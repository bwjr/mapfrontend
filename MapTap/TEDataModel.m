//
//  TEDataModel.m
//  MapTap
//
//  Created by Billy Rathje on 12/21/12.
//  Copyright (c) 2012 Billy Rathje. All rights reserved.
//

#import "TEDataModel.h"
#import <MapKit/MapKit.h>

@implementation TEDataModel

- (id) init
{
    if(self = [super init])
    {
        self.annotations = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
