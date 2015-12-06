//
//  EGSignTeacherViewController.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 29.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGCoreDataViewController.h"
#import "EGCourse.h"
#import "EGSignStudentsViewController.h" // импортировали класс, так как в нем реализован протокол EGCourseInfoDelegate, и здесь он нам также понадобится

@protocol EGCourseInfoDelegate;

@interface EGSignTeacherViewController : EGCoreDataViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) EGCourse* course;
@property (weak, nonatomic) id <EGCourseInfoDelegate> delegate;


@end
