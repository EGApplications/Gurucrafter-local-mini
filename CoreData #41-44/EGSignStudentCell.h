//
//  EGSignStudentCell.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 29.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGSignStudentCell : UITableViewCell

// Кастомная ячейка для отображения информации о студенте и его статусе - подписан на курс или нет.

@property (weak, nonatomic) IBOutlet UILabel *initials;
@property (weak, nonatomic) IBOutlet UIImageView *signStatus;

@end
