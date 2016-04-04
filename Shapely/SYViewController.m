//
//  SYViewController.m
//  Shapely
//
//  Created by Andres Socha on 7/27/14.
//  Copyright (c) 2014 AndreSocha. All rights reserved.
//

#import "SYViewController.h"
#import "SYShapeView.h"

@interface SYViewController ()
{
    NSArray *colors;
}
-(IBAction)moveShape:(UIPanGestureRecognizer *)gesture;
@property (readonly,nonatomic) NSArray *colors;
@end

@implementation SYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)addShape:(id)sender
{
    SYShapeView *shapeView=[[SYShapeView alloc]initWithShape:[sender tag]];
    shapeView.color=[self.colors objectAtIndex:arc4random_uniform(self.colors.count)];
    [self.view addSubview:shapeView];
    
    /*Draw in a random location*/
    CGRect shapeFrame=shapeView.frame;
    CGRect safeRect=CGRectInset(self.view.bounds,
                                shapeFrame.size.width,
                                shapeFrame.size.height);
    CGPoint newLoc=CGPointMake(safeRect.origin.x
                               +arc4random_uniform(safeRect.size.width),
                               +safeRect.origin.y
                               +arc4random_uniform(safeRect.size.height));
    shapeView.center=newLoc;
    
    /*One tap gesture recognizer*/
    UIPanGestureRecognizer *panRecognizer;
    panRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self
                                                         action:@selector(moveShape:)];
    panRecognizer.maximumNumberOfTouches=1;
    [shapeView addGestureRecognizer:panRecognizer];
    
    /*double tap gesture recognizer*/
    UITapGestureRecognizer *dblTapGesture;
    dblTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeColor:)];
    dblTapGesture.numberOfTapsRequired=2;
    [shapeView addGestureRecognizer:dblTapGesture];
    
    /*Triple tap gesture recognizer*/
    UITapGestureRecognizer *trplTapGesture;
    trplTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendShapeToBack:)];
    trplTapGesture.numberOfTapsRequired=3;
    [shapeView addGestureRecognizer:trplTapGesture];
    
    //This line prevents double gesture from triggering before triple tap executes
    [dblTapGesture requireGestureRecognizerToFail:trplTapGesture];
    
    /*Pinch gesture recognizer*/
    UIPinchGestureRecognizer *pinchGesture;
    pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(resizeShape:)];
    [shapeView addGestureRecognizer:pinchGesture];
    
    /*Animation*/
    shapeFrame=shapeView.frame;//Optional for removal
    CGRect buttonFrame=((UIView*)sender).frame;
    
    shapeView.frame=buttonFrame;
    [UIView animateWithDuration:0.5
                     delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{shapeView.frame = shapeFrame;}
                     completion:nil];
    
}

-(NSArray*)colors
{
    if (colors==nil)
    {
        colors=@[UIColor.redColor,UIColor.greenColor,
                 UIColor.blueColor,UIColor.yellowColor,
                 UIColor.purpleColor,UIColor.orangeColor,
                 UIColor.grayColor,UIColor.whiteColor];
    }
    return colors;
}

-(IBAction)moveShape:(UIPanGestureRecognizer *)gesture
{
    SYShapeView *shapeView=(SYShapeView *)gesture.view;
    CGPoint dragDelta=[gesture translationInView:shapeView.superview];
    CGAffineTransform move;
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            move=CGAffineTransformMakeTranslation(dragDelta.x, dragDelta.y);
            shapeView.transform=move;
            break;
            
        case UIGestureRecognizerStateEnded:
            shapeView.transform=CGAffineTransformIdentity;
            shapeView.frame=CGRectOffset(shapeView.frame, dragDelta.x, dragDelta.y);
            break;
            
        default:
            shapeView.transform=CGAffineTransformIdentity;
            break;
    }
}

-(IBAction)resizeShape:(UIPinchGestureRecognizer*)gesture
{
    SYShapeView *shapeView=(SYShapeView*)gesture.view;
    CGFloat pinchScale=gesture.scale;
    CGAffineTransform zoom;
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            zoom=CGAffineTransformMakeScale(pinchScale, pinchScale);
            shapeView.transform=zoom;
            break;
        
        case UIGestureRecognizerStateEnded:
            shapeView.transform=CGAffineTransformIdentity;
            CGRect frame=shapeView.frame;
            CGFloat xDelta=frame.size.width*pinchScale-frame.size.width;
            CGFloat yDelta=frame.size.height*pinchScale-frame.size.height;
            frame.size.width += xDelta;
            frame.size.height += yDelta;
            frame.origin.x -= xDelta/2;
            frame.origin.y -= yDelta/2;
            shapeView.frame=frame;
            [shapeView setNeedsDisplay];
            break;
            
        default:
            shapeView.transform = CGAffineTransformIdentity;
            break;
    }
}

-(IBAction)changeColor:(UITapGestureRecognizer*)gesture
{
    SYShapeView *shapeView=(SYShapeView*)gesture.view;
    UIColor *color=shapeView.color;
    NSUInteger colorIndex=[self.colors indexOfObject:color];
    
    NSUInteger newIndex;
    do{
        newIndex=arc4random_uniform(self.colors.count);
    }while (colorIndex==newIndex);
    shapeView.color=[self.colors objectAtIndex:newIndex];
}

-(IBAction)sendShapeToBack :(UITapGestureRecognizer*)gesture
{
    UIView *shapeView=gesture.view;
    [self.view sendSubviewToBack:shapeView];
}
@end
