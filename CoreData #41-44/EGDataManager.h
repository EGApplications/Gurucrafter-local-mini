//
//  EGDataManager.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 03.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

// DataManager нужен для непосредственной работы с базой данных

@interface EGDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (EGDataManager*) sharedManager;

// Student methods ===========================

- (void) addRandomStudents:(NSInteger) count;
- (void) deleteAllStudents;

// Два метода для непосредственного добавления и удаления студентов по одному. Надо реализовать!!!
- (void) deleteStudent:(id) student;
- (void) addStudent:(id) student;

// Courses methods ===========================

- (void) addAllCourses;
- (void) deleteAllCourses;

// Teachers methods ==========================

- (void) addTeachers;
- (void) deleteAllTeachers;

@end
