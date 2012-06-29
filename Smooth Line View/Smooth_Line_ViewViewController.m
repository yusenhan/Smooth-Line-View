//
//  Smooth_Line_ViewViewController.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/10/11.
//  Copyright 2011 culturezoo. All rights reserved.
//
//  modify by Hanson @ Splashtop

#import "Smooth_Line_ViewViewController.h"

@implementation Smooth_Line_ViewViewController

- (void)viewDidLoad
{
    slv = [[[SmoothLineView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.view addSubview:slv];
    
    UIButton *undoButton=[UIButton  buttonWithType:UIButtonTypeCustom];
    [undoButton setTitle:@"UNDO" forState:UIControlStateNormal];
    [undoButton setBackgroundColor:[UIColor blackColor]];
    undoButton.frame=CGRectMake(0, 0, 100, 40);
    [undoButton addTarget:self action:@selector(undoButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:undoButton];
    
    UIButton *redoButton=[UIButton  buttonWithType:UIButtonTypeCustom];
    [redoButton setTitle:@"REDO" forState:UIControlStateNormal];
    [redoButton setBackgroundColor:[UIColor blackColor]];
    redoButton.frame=CGRectMake(120, 0, 100, 40);
    [redoButton addTarget:self action:@selector(redoButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:redoButton];
    
    UIButton *resetButton=[UIButton  buttonWithType:UIButtonTypeCustom];
    [resetButton setTitle:@"CLEAR" forState:UIControlStateNormal];
    [resetButton setBackgroundColor:[UIColor blackColor]];
    resetButton.frame=CGRectMake(240, 0, 100, 40);
    [resetButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:resetButton];
    
    UIButton *eraserButton=[UIButton  buttonWithType:UIButtonTypeCustom];
    [eraserButton setTitle:@"ERASER" forState:UIControlStateNormal];
    [eraserButton setBackgroundColor:[UIColor blackColor]];
    eraserButton.frame=CGRectMake(360, 0, 100, 40);
    [eraserButton addTarget:self action:@selector(eraserButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:eraserButton];
    
    UIButton *blueColorButton=[UIButton  buttonWithType:UIButtonTypeCustom];
    [blueColorButton setTag:101];
    [blueColorButton setTitle:@"" forState:UIControlStateNormal];
    [blueColorButton setBackgroundColor:[UIColor blueColor]];
    blueColorButton.frame=CGRectMake(500, 0, 40, 40);
    [blueColorButton addTarget:self action:@selector(changeColorClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:blueColorButton];
    
    UIButton *redColorButton=[UIButton  buttonWithType:UIButtonTypeCustom];
    [redColorButton setTag:102];
    [redColorButton setTitle:@"" forState:UIControlStateNormal];
    [redColorButton setBackgroundColor:[UIColor redColor]];
    redColorButton.frame=CGRectMake(550, 0, 40, 40);
    [redColorButton addTarget:self action:@selector(changeColorClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:redColorButton];
    
    UIButton *greenColorButton=[UIButton  buttonWithType:UIButtonTypeCustom];
    [greenColorButton setTag:103];
    [greenColorButton setTitle:@"" forState:UIControlStateNormal];
    [greenColorButton setBackgroundColor:[UIColor greenColor]];
    greenColorButton.frame=CGRectMake(600, 0, 40, 40);
    [greenColorButton addTarget:self action:@selector(changeColorClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:greenColorButton];
    
    [super viewDidLoad];

}



-(IBAction)undoButtonClicked:(id)sender
{
    [slv undoButtonClicked];
    
}

-(IBAction)redoButtonClicked:(id)sender
{
    [slv redoButtonClicked];
    
}

-(IBAction)clearButtonClicked:(id)sender
{
    [slv clearButtonClicked];
    
}

-(IBAction)eraserButtonClicked:(id)sender
{
    [slv eraserButtonClicked];
    
}



-(IBAction)changeColorClicked:(id)sender
{
    UIButton *_button = (UIButton*)sender;
    switch (_button.tag) {
        case 101:
        {
            [slv setColor:[UIColor blueColor]];
        }
            break;
        case 102:
        {
            [slv setColor:[UIColor redColor]];            
        }
            break;
        case 103:
        {
            [slv setColor:[UIColor greenColor]];            
        }
            break;
        default:
            break;
    }
}



@end


