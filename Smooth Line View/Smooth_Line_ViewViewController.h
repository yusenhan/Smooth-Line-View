//
//  Smooth_Line_ViewViewController.h
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//
//  modify by Hanson @ Splashtop

#import <UIKit/UIKit.h>
#import "SmoothLineView.h"
#import "InfColorPicker.h"

@interface Smooth_Line_ViewViewController : UIViewController <InfColorPickerControllerDelegate,UIPopoverControllerDelegate>
{
    SmoothLineView *slv;  
    UIPopoverController* activePopover;
}

@property (nonatomic, retain) IBOutlet UIButton *undoButton;
@property (nonatomic, retain) IBOutlet UIButton *redoButton;
@property (nonatomic, retain) IBOutlet UIButton *clearButton;
@property (nonatomic, retain) IBOutlet UIButton *eraserButton;
@property (nonatomic, retain) IBOutlet UIButton *save2FileButton;
@property (nonatomic, retain) IBOutlet UIButton *save2AlbumButton;

-(void) setUndoButtonEnable:(NSNumber*)isEnable;
-(void) setRedoButtonEnable:(NSNumber*)isEnable;
-(void) setClearButtonEnable:(NSNumber*)isEnable;
-(void) setEraserButtonEnable:(NSNumber*)isEnable;
-(void) setSave2FileButtonEnable:(NSNumber*)isEnable;
-(void) setSave2AlbumButtonEnable:(NSNumber*)isEnable;

@end
