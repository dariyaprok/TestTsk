//
//  NSArray+EEContainsElementsOfArray.m
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "NSArray+EEContainsElementsOfArray.h"

@implementation NSArray (ContainsElementsOfArray)
- (BOOL)containsElementsOfArray:(NSArray*)array{
    for (id object in array)
        if (![self containsObject:object])
            return NO;
    return YES;
}
@end

