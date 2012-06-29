//
//  SmoothLineView.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/15/11.
//  Copyright 2011 culturezoo. All rights reserved.
//
//  modify by Hanson @ Splashtop

#import "SmoothLineView.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_COLOR [UIColor blackColor]
#define DEFAULT_WIDTH 5.0f
#define DEFAULT_ALPHA 1.0f

@interface SmoothLineView () 

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2);

@end

@implementation SmoothLineView

@synthesize lineAlpha;
@synthesize lineColor;
@synthesize lineWidth;
@synthesize delegate;

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = DEFAULT_WIDTH;
        self.lineColor = DEFAULT_COLOR;
        self.lineAlpha = DEFAULT_ALPHA;
        
        bufferArray=[[NSMutableArray alloc]init];
        lineArray=[[NSMutableArray alloc]init];
        colorArray=[[NSMutableArray alloc]init]; 
        
        /*
        UIPanGestureRecognizer *recognizer;
        
        recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(handleDrawing:)];
        recognizer.minimumNumberOfTouches = 1;
        recognizer.maximumNumberOfTouches = 1;
        
        [self addGestureRecognizer:recognizer];
        [recognizer release];
         */
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    switch (drawStep) {
        case DRAW:
        {
            [curImage drawAtPoint:CGPointMake(0, 0)];
            CGPoint mid1 = midPoint(previousPoint1, previousPoint2); 
            CGPoint mid2 = midPoint(currentPoint, previousPoint1);
            CGContextRef context = UIGraphicsGetCurrentContext(); 
            
            [self.layer renderInContext:context];
            CGContextMoveToPoint(context, mid1.x, mid1.y);
            CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y); 
            CGContextSetLineCap(context, kCGLineCapButt);
            CGContextSetLineWidth(context, self.lineWidth);
            CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
            CGContextSetAlpha(context, self.lineAlpha);
            CGContextStrokePath(context);            
            [super drawRect:rect];
            [curImage release];

        }
            break;
        case CLEAR:
        {
            CGContextRef context = UIGraphicsGetCurrentContext(); 
            CGContextClearRect(context, rect);
            break;
        }
        case ERASE:
        {
            [curImage drawAtPoint:CGPointMake(0, 0)];
            CGContextRef context = UIGraphicsGetCurrentContext(); 
            CGContextClearRect(context, rect);
            [super drawRect:rect];
            [curImage release];

        }
            break;
        case UNDO:
        {
            [curImage drawInRect:self.bounds];   
            break;
        }
        case REDO:
        {
            [curImage drawInRect:self.bounds];   
            break;
        }
            
        default:
            break;
    }    
}

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark Gesture handle

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch locationInView:self];
    previousPoint2 = [touch locationInView:self];
    currentPoint = [touch locationInView:self];
    
    pathArray=[NSMutableArray new];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch  = [touches anyObject];
    
    previousPoint2  = previousPoint1;
    previousPoint1  = currentPoint;
    currentPoint    = [touch locationInView:self];
    
    NSArray *points = [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:previousPoint2],
                       [NSValue valueWithCGPoint:previousPoint1],
                       [NSValue valueWithCGPoint:currentPoint],
                       nil];
    
    [pathArray addObject:points];
    if (1)
    {
        if(drawStep != ERASE) 
            drawStep = DRAW;
        [self calculateMinImageArea:previousPoint1 :previousPoint2 :currentPoint];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSString  *pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Test.png"];

    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    [curImage retain];
    UIGraphicsEndImageContext();
//    [UIImagePNGRepresentation(curImage) writeToFile:pngPath atomically:YES];
    
    NSDictionary *lineInfo = [NSDictionary dictionaryWithObjectsAndKeys:curImage, @"IMAGE",
                              nil];
    
    [lineArray addObject:lineInfo];
    [pathArray removeAllObjects];
    [pathArray release]; pathArray = nil;
    
    
    [curImage release];
    
    [self checkDrawStatus];
    
}


//UIPanGestureRecognizer will get bug. why?

/*
- (void)handleDrawing:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point  = [recognizer locationInView:self];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            previousPoint1 = point;
            previousPoint2 = point;
            currentPoint = point;
            
            pathArray=[[NSMutableArray alloc]init];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            
            previousPoint2  = previousPoint1;
            previousPoint1  = currentPoint;
            currentPoint    = point;
            
            NSArray *points = [NSArray arrayWithObjects:
                               [NSValue valueWithCGPoint:previousPoint2],
                               [NSValue valueWithCGPoint:previousPoint1],
                               [NSValue valueWithCGPoint:currentPoint],
                               nil];
            
            [pathArray addObject:points];
            if (1)
            {
                [self calculateMinImageArea:previousPoint1 :previousPoint2 :currentPoint];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            
            
            NSDictionary *lineInfo = [NSDictionary dictionaryWithObjectsAndKeys:[pathArray copy], @"LINEARRAY",
                                      self.lineColor, @"COLOR",
                                      [NSNumber numberWithDouble:self.lineAlpha], @"ALPHA",
                                      [NSNumber numberWithDouble:self.lineWidth], @"WIDTH",
                                      nil];
            
            [lineArray addObject:lineInfo];
            [pathArray removeAllObjects];
            [pathArray release]; pathArray = nil;
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}

 */

#pragma mark Private Helper function


- (void) calculateMinImageArea:(CGPoint)pp1 :(CGPoint)pp2 :(CGPoint)cp
{
    
    // calculate mid point
    CGPoint mid1    = midPoint(pp1, pp2); 
    CGPoint mid2    = midPoint(cp, pp1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, pp1.x, pp1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.lineWidth * 2;
    drawBox.origin.y        -= self.lineWidth * 2;
    drawBox.size.width      += self.lineWidth * 4;
    drawBox.size.height     += self.lineWidth * 4;
    
    UIGraphicsBeginImageContext(drawBox.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    [curImage retain];
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplayInRect:drawBox];
    
    //http://stackoverflow.com/a/4766028/489594
    [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
    
}



-(void)redrawLine
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    NSDictionary *lineInfo = [lineArray lastObject];
    curImage = (UIImage*)[lineInfo valueForKey:@"IMAGE"];
    UIGraphicsEndImageContext();
    [self setNeedsDisplayInRect:self.bounds];    
}


#pragma mark Button Handle

-(void)undoButtonClicked
{
    if([lineArray count]>0){
        NSMutableArray *_line=[lineArray lastObject];
        [bufferArray addObject:[_line copy]];
        [lineArray removeLastObject];
        drawStep = UNDO;
        [self redrawLine];
    }
    [self checkDrawStatus];
}

-(void)redoButtonClicked
{
    if([bufferArray count]>0){
        NSMutableArray *_line=[bufferArray lastObject];
        [lineArray addObject:_line];
        [bufferArray removeLastObject];
        drawStep = REDO;
        [self redrawLine];
    }
    [self checkDrawStatus];
}
-(void)clearButtonClicked
{    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    [curImage retain];
    UIGraphicsEndImageContext();
    drawStep = CLEAR;
    [self setNeedsDisplayInRect:self.bounds];
    [lineArray removeAllObjects];
    [bufferArray removeAllObjects];
    [self checkDrawStatus];
}

-(void)eraserButtonClicked
{    
    if(drawStep!=ERASE)
    {
        drawStep = ERASE;
    }
    else 
    {
        drawStep = DRAW;
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {  
    NSString *message;  
    NSString *title;  
    if (!error) {  
        title = NSLocalizedString(@"SaveSuccessTitle", @"");  
        message = NSLocalizedString(@"SaveSuccessMessage", @"");  
    } else {  
        title = NSLocalizedString(@"SaveFailedTitle", @"");  
        message = [error description];  
    }  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  
                                                    message:message  
                                                   delegate:nil  
                                          cancelButtonTitle:NSLocalizedString(@"ButtonOK", @"")  
                                          otherButtonTitles:nil];  
    [alert show];  
    [alert release];  
}  

-(void)setColor:(float)r g:(float)g b:(float)b a:(float)a
{
    self.lineColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
}

-(void)save2FileButtonClicked
{
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
        
    NSString  *pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Screenshot %@.png",dateString]];
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [UIImagePNGRepresentation(saveImage) writeToFile:pngPath atomically:YES];
    
}

//ref: http://iphoneincubator.com/blog/tag/uigraphicsbeginimagecontext
-(void)save2AlbumButtonClicked
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:),context);
}

#pragma mark toolbarDelegate Handle
- (void) checkDrawStatus
{
    if([lineArray count]>0)
    {
        [delegate performSelectorOnMainThread:@selector(setUndoButtonEnable:)
								   withObject:[NSNumber numberWithBool:YES]
								waitUntilDone:NO];
        [delegate performSelectorOnMainThread:@selector(setClearButtonEnable:)
								   withObject:[NSNumber numberWithBool:YES]
								waitUntilDone:NO];
        [delegate performSelectorOnMainThread:@selector(setEraserButtonEnable:)
								   withObject:[NSNumber numberWithBool:YES]
								waitUntilDone:NO];
        [delegate performSelectorOnMainThread:@selector(setSave2FileButtonEnable:)
								   withObject:[NSNumber numberWithBool:YES]
								waitUntilDone:NO];
        [delegate performSelectorOnMainThread:@selector(setSave2AlbumButtonEnable:)
								   withObject:[NSNumber numberWithBool:YES]
								waitUntilDone:NO];

    }
    else 
    {
        [delegate performSelectorOnMainThread:@selector(setUndoButtonEnable:)
								   withObject:[NSNumber numberWithBool:NO]
								waitUntilDone:NO];
        [delegate performSelectorOnMainThread:@selector(setClearButtonEnable:)
								   withObject:[NSNumber numberWithBool:NO]
								waitUntilDone:NO];
        [delegate performSelectorOnMainThread:@selector(setEraserButtonEnable:)
								   withObject:[NSNumber numberWithBool:NO]
								waitUntilDone:NO];
        [delegate performSelectorOnMainThread:@selector(setSave2FileButtonEnable:)
								   withObject:[NSNumber numberWithBool:NO]
								waitUntilDone:NO];
        [delegate performSelectorOnMainThread:@selector(setSave2AlbumButtonEnable:)
								   withObject:[NSNumber numberWithBool:NO]
								waitUntilDone:NO];
    }
    
    if([bufferArray count]>0)
    {
        [delegate performSelectorOnMainThread:@selector(setRedoButtonEnable:)
								   withObject:[NSNumber numberWithBool:YES]
								waitUntilDone:NO];

    }
    else 
    {
        [delegate performSelectorOnMainThread:@selector(setRedoButtonEnable:)
								   withObject:[NSNumber numberWithBool:NO]
								waitUntilDone:NO];
    }
}

@end


