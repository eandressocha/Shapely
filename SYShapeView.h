//
//  SYShapeView.h
//  Shapely
//
//  Created by Andres Socha on 7/27/14.
//  Copyright (c) 2014 AndreSocha. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kSquareShape=1,
    kRectangleShape,
    kCircleShape,
    kOvalShape,
    kTriangleShape,
    kStarShape,
}ShapeSelector;

@interface SYShapeView : UIView

-(id)initWithShape:(ShapeSelector)theShape;
@property (strong,nonatomic)UIColor *color;

@end
