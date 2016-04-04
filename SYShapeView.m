//
//  SYShapeView.m
//  Shapely
//
//  Created by Andres Socha on 7/27/14.
//  Copyright (c) 2014 AndreSocha. All rights reserved.
//

#import "SYShapeView.h"
#define kInitialDimension           100.0f
#define kInitialAlternateHeight     (kInitialDimension/2)
#define kStrokeWidth                8.0f

@interface SYShapeView()
{
    ShapeSelector shape;
}
@property (readonly, nonatomic)UIBezierPath *path;

@end
@implementation SYShapeView

-(id)initWithShape:(ShapeSelector)theShape
{
    CGRect initRect=CGRectMake(0,0, kInitialDimension, kInitialDimension);
    if (theShape==kRectangleShape || theShape==kOvalShape)
        initRect.size.height=kInitialAlternateHeight;
    
    self=[super initWithFrame:initRect];
    
    if (self!=nil)
    {
        shape=theShape;
        self.opaque=NO;
        self.backgroundColor=nil;
        self.clearsContextBeforeDrawing=YES;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *path=self.path;
    [[[UIColor blackColor]colorWithAlphaComponent:0.3]setFill];
    [path fill];
    [self.color setStroke];
    [path stroke];
}

-(UIBezierPath*)path
{
    CGRect bounds=self.bounds;
    CGRect rect=CGRectInset(bounds, kStrokeWidth/2+1, kStrokeWidth/2+1);
    
    UIBezierPath *path;
    switch (shape)
    {
        case kSquareShape:
        case kRectangleShape:
            path=[UIBezierPath bezierPathWithRect:rect];
            break;
        
        case kCircleShape:
        case kOvalShape:
            path=[UIBezierPath bezierPathWithOvalInRect:rect];
            break;
        
        case kTriangleShape:
            path=[UIBezierPath bezierPath];
            CGPoint point=CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            [path moveToPoint:point];
            point=CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
            [path addLineToPoint:point];
            point=CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
            [path addLineToPoint:point];
            [path closePath];
            break;
            
        case kStarShape:
            path=[UIBezierPath bezierPath];
            point=CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            float angle=M_PI*2/5;
            float distance=rect.size.width*0.38f;
            [path moveToPoint:point];
            for (NSUInteger arm=0; arm<5; arm++)
            {
                point.x += cosf(angle)*distance;
                point.y += sinf(angle)*distance;
                [path addLineToPoint:point];
                angle -= M_PI*2/5;
                point.x +=cosf(angle)*distance;
                point.y +=sinf(angle)*distance;
                [path addLineToPoint:point];
                angle += M_PI*4/5;
            }
            [path closePath];
            break;
    }
    path.lineWidth=kStrokeWidth;
    path.lineJoinStyle=kCGLineJoinRound;
    return path;
}
-(void)setColor:(UIColor *)color
{
    _color=color;
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
