//
//  NSDate+EEToString.m
//  TestTask
//
//  Created by админ on 10/7/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "NSDate+EEToString.h"

@implementation NSDate (EEToString)

-(NSString*)transformToString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:self];
    return stringFromDate;
}
@end
