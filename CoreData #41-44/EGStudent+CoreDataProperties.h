//
//  EGStudent+CoreDataProperties.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 01.12.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EGStudent.h"
#import "EGCourse.h"

NS_ASSUME_NONNULL_BEGIN

// Сущности из кор даты, сделанные как класс для более легкого доступа к данным сущностей.

@interface EGStudent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *surname;
@property (nullable, nonatomic, retain) NSSet<EGCourse *> *courses;

@end

@interface EGStudent (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(EGCourse *)value;
- (void)removeCoursesObject:(EGCourse *)value;
- (void)addCourses:(NSSet<EGCourse *> *)values;
- (void)removeCourses:(NSSet<EGCourse *> *)values;

@end

NS_ASSUME_NONNULL_END
