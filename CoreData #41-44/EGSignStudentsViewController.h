//
//  EGSignStudentsViewController.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 29.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGCoreDataViewController.h"
#import "EGCourse.h"

@protocol EGCourseInfoDelegate <NSObject>
// С помощью данных методов в протоколе, будем сообщать делегату, какого преподавателя выбрали на курс, и каких студентов подписали на курс.

- (void) courseTeacher:(EGTeacher*) teacher;
- (void) courseStudents:(NSSet*) students;

@end

@interface EGSignStudentsViewController : EGCoreDataViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) EGCourse* course;
@property (weak, nonatomic) id <EGCourseInfoDelegate> delegate;

@end
