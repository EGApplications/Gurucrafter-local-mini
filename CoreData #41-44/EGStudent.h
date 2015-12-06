//
//  EGStudent.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 03.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGStudent : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *surname;
@property (nullable, nonatomic, retain) NSString *email;

@end

NS_ASSUME_NONNULL_END

#import "EGStudent+CoreDataProperties.h"
