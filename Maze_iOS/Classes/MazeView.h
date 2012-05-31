//
//  MazeView.h
//  Maze
//
//  Created by He JiaBin on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "MazeLogic.h"


@interface MazeView : UIView 
{
@private
	
	CADisplayLink* m_tick;
	CGContextRef m_buffer;
	CGRect m_bufferBound;
	void* m_pBuffer;
	
	int m_stateStack[10];
	int m_curStateIndex;
	
	int m_stepCnt;
}

- (void) gameInit;
- (void) gameLogic;

- (IBAction)_onLeftPress:(id)sender;
- (IBAction)_onRightPress:(id)sender;
- (IBAction)_onUpPress:(id)sender;
- (IBAction)_onDownPress:(id)sender;

- (IBAction)_onLeftRelease:(id)sender;
- (IBAction)_onRightRelease:(id)sender;
- (IBAction)_onUpRelease:(id)sender;
- (IBAction)_onDownRelease:(id)sender;

@end
