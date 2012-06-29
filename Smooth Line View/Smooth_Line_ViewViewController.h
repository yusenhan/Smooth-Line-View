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
#import "UIGlossyButton.h"

@interface Smooth_Line_ViewViewController : UIViewController <InfColorPickerControllerDelegate,UIPopoverControllerDelegate>
{
    SmoothLineView *slv;  
    UIPopoverController* activePopover;
}

@property (nonatomic, retain) UIGlossyButton *undoButton;
@property (nonatomic, retain) UIGlossyButton *redoButton;
@property (nonatomic, retain) UIGlossyButton *clearButton;
@property (nonatomic, retain) UIGlossyButton *eraserButton;
@property (nonatomic, retain) UIGlossyButton *colorButton;
@property (nonatomic, retain) UIGlossyButton *save2FileButton;
@property (nonatomic, retain) UIGlossyButton *save2AlbumButton;

-(void) initButton;

-(void) setUndoButtonEnable:(NSNumber*)isEnable;
-(void) setRedoButtonEnable:(NSNumber*)isEnable;
-(void) setClearButtonEnable:(NSNumber*)isEnable;
-(void) setEraserButtonEnable:(NSNumber*)isEnable;
-(void) setSave2FileButtonEnable:(NSNumber*)isEnable;
-(void) setSave2AlbumButtonEnable:(NSNumber*)isEnable;

@end
