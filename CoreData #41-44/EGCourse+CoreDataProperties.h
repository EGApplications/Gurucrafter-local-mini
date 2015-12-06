//
//  EGCourse+CoreDataProperties.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 29.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EGCourse.h"
#import "EGTeacher.h"

NS_ASSUME_NONNULL_BEGIN

@interface EGCourse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *branch;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSSet<EGStudent *> *students;
@property (nullable, nonatomic, retain) EGTeacher *teacher;

@end

@interface EGCourse (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(EGStudent *)value;
- (void)removeStudentsObject:(EGStudent *)value;
- (void)addStudents:(NSSet<EGStudent *> *)values;
- (void)removeStudents:(NSSet<EGStudent *> *)values;

@end

NS_ASSUME_NONNULL_END
