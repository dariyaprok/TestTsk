//
//  Person+Methods.m
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "Person+Methods.h"

@implementation Person (Methods)

- (NSString*)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.name, self.lastname];
}
@end
