//
//  Person.h
//  
//
//  Created by админ on 10/7/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photoUrl;

@end
