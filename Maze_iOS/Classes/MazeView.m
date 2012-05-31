//
//  MazeView.m
//  Maze
//
//  Created by He JiaBin on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MazeView.h"


// private functions
@interface MazeView(private)

- (void)createBuffer;
- (void)drawPixel:(BOOL)dot toX:(int)X toY:(int)Y;
- (void)drawBlock:(Byte*)data toX:(int)X toY:(int)Y;
- (void)drawBlock:(Byte*)data toX:(int)X toY:(int)Y isReverse:(BOOL)reverse;
- (void)eraseBlock:(int)X toY:(int)Y;
- (void)drawFrame:(int)left toTop:(int)top toRight:(int)right toBottom:(int)bottom;
- (void)drawEdge;
- (void)drawMap;
- (void)movLeft;
- (void)movRight;
- (void)movUp;
- (void)movDown;
- (void)drawMan;
- (void)drawTreasure;
- (void)updateInfo;
- (void)drawBlood:(int)X toY:(int)Y;

- (void)gameStart;
- (void)gameWin;
- (void)gameLose;
- (void)gameEnd;
- (void)gameFind;
- (void)gameMove;
- (void)endLoop;

- (void)gotoState:(int)state;
- (void)quitToState:(int)state;
- (void)popState;
@end


@implementation MazeView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	
	self = [super initWithCoder:aDecoder];
	if( self )
	{
		// init the game
		[self gameInit];
		
		// start the game loop
		self->m_tick = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLogic)];		
		self->m_tick.frameInterval = 2;		
		[m_tick addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	}
	
	return self;
}

// Init the game
- (void) gameInit
{
	[self createBuffer];
	
	//game logic init
	offsetX = 0;
	offsetY = 0;
	manX = 1;
	manY = 1;
	manDirection = 0;
	treasureNum = 9;
	step = 0;
	maxStep = 500;
	m_stepCnt = 0;

	m_curStateIndex = 0;
	m_stateStack[m_curStateIndex] = GAME_STATE_START;
	gameState=GAME_STATE_START;
}

// Frame function
- (void) gameLogic
{
	switch (gameState) 
    {
        case GAME_STATE_START:
            [self gameStart];  
            break;
        case GAME_STATE_WIN:
            [self gameWin];
            break;
        case GAME_STATE_LOSE:
            [self gameLose];
            break;
        case GAME_STATE_FIND:
            [self gameFind];
            break;
        case GAME_STATE_MOVE:
            [self gameMove];
            break;
        case GAME_STATE_END:
            [self gameEnd];
            break;
        default:
			[self endLoop];
            break;
    }
	
	m_stepCnt++;
	
	[self setNeedsDisplay];
}

- (void)gameStart
{
	switch (m_stepCnt) {
		case 0:
			[self drawFrame:0 toTop:0 toRight:240 toBottom:128];
			break;
		case 15:
			[self drawFrame:16 toTop:16 toRight:224 toBottom:112];
			break;
		case 30:
			[self drawFrame:32 toTop:32 toRight:208 toBottom:96];
			break;
		case 45:
			[self drawFrame:48 toTop:48 toRight:192 toBottom:80];
			break;
		case 60:
			[self drawBlock:mi toX:70 toY:56];
			break;
		case 70:
			[self drawBlock:gong2 toX:86 toY:56];
			break;
		case 80:
			[self drawBlock:xun toX:102 toY:56];
			break;
		case 90:
			[self drawBlock:bao toX:118 toY:56];
			break;
		case 100:
			[self drawBlock:treasure toX:144 toY:56];
			break;
		case 175:
			[self drawMap];
			[self drawEdge];
			[self updateInfo];
			[self drawMan];
			[self drawTreasure];
			[self quitToState:GAME_STATE_MOVE];
			break;
		default:
			break;
	}
}

- (void)gameWin
{
    switch (m_stepCnt) {
		case 0:
			[self drawBlock:edgeMini toX:72 toY:56];
			break;
		case 3:
			[self drawFrame:64 toTop:48 toRight:96 toBottom:80];
			break;
		case 6:
			[self drawFrame:48 toTop:44 toRight:112 toBottom:84];
			[self drawBlock:ni toX:56 toY:56];
			[self drawBlock:ying toX:72 toY:56];
			[self drawBlock:le toX:88 toY:56];
			break;
		case 36:
			[self quitToState:GAME_STATE_END];
			break;
		default:
			break;
	}
}

- (void)gameLose
{
    switch (m_stepCnt) {
		case 0:
			[self drawBlock:edgeMini toX:72 toY:56];
			break;
		case 3:
			[self drawFrame:64 toTop:48 toRight:96 toBottom:80];
			break;
		case 6:
			[self drawFrame:48 toTop:44 toRight:112 toBottom:84];
			[self drawBlock:ni toX:56 toY:56];
			[self drawBlock:shu toX:72 toY:56];
			[self drawBlock:le toX:88 toY:56];
			break;
		case 36:
			[self quitToState:GAME_STATE_END];
			break;
		default:
			break;
	}
}

- (void)gameEnd
{
	int i, j;
	
	if( m_stepCnt <= 120 )
	{
		i = (m_stepCnt - 1) % 15;
		j = (m_stepCnt - 1) / 15;
		[self drawBlock:blank toX:i*16 toY:j*16];
		
		return;
	}
	
    switch(m_stepCnt)
	{
		case 130:
			[self drawBlock:cheng toX:60 toY:40];
			break;
		case 145:
			[self drawBlock:xu toX:76 toY:40];
			break;
		case 160:
			[self drawBlock:he toX:120 toY:40];
			break;
		case 175:
			[self drawBlock:jia toX:136 toY:40];
			break;
		case 190:
			[self drawBlock:bin toX:152 toY:40];
			break;
		case 205:
			[self popState];
			break;
		default:
			break;
	}
}

- (void)gameFind
{
	switch (m_stepCnt) {
		case 1:
			[self drawBlock:edgeMini toX:72 toY:56];
			break;
		case 4:
			[self drawFrame:64 toTop:48 toRight:96 toBottom:80];
			break;
		case 7:
			[self drawFrame:48 toTop:44 toRight:112 toBottom:84];
			[self drawBlock:zhao toX:56 toY:56];
			[self drawBlock:dao toX:72 toY:56];
			[self drawBlock:treasure toX:88 toY:56];
			break;
		case 37:
			[self popState];
			break;
		default:
			break;
	}
}

- (void)gameMove
{
	if( keys[KEY_RIGHT] == YES )
	{
		[self movRight];
		manDirection = 0;
		keys[KEY_RIGHT] = NO;
	}
	if( keys[KEY_LEFT] == YES )
	{
		[self movLeft];
		manDirection = 2;
		keys[KEY_LEFT] = NO;
	}
	if( keys[KEY_UP] == YES )
	{
		[self movUp];
		manDirection = 1;
		keys[KEY_UP] = NO;
	}
	if( keys[KEY_DOWN] == YES )
	{
		[self movDown];
		manDirection = 3;
		keys[KEY_DOWN] = NO;
	}
	
	int i;
	for( i = 0; i < 9; i++ )
	{
		if( allTreasure[i].beFind == NO )
		{
			if( allTreasure[i].xpos == manX && allTreasure[i].ypos == manY )
			{
				allTreasure[i].beFind = YES;
				treasureNum--;
				step -= 10;
				[self gotoState:GAME_STATE_FIND];
				
				return;
			}
		}
	}
	
	[self updateInfo];
	[self drawMap];
	[self drawMan];
	[self drawTreasure];
	
    if( treasureNum == 0 )
	{
		[self quitToState:GAME_STATE_WIN];
		return;
	}
	
	if( step > maxStep )
	{
		[self quitToState:GAME_STATE_LOSE];
		return;
	}
}

- (void)endLoop
{
	static BOOL _flag = YES;
	int i;
	
	if( m_stepCnt > 10 )
	{
		for ( i = 0; i < 8; i++ ) 
		{
			[self drawBlock:wall toX:0 toY:i*16 isReverse:(i%2?_flag:!_flag)];
			[self drawBlock:wall toX:224 toY:i*16 isReverse:(i%2?_flag:!_flag)];
		}
		
		m_stepCnt = 0;
		_flag = !_flag;
	}
}

// Create the display buffer for render
- (void)createBuffer
{
	CGColorSpaceRef colorSpace;
	void* bitmapData;
	int bitmapByteCount;
	int bitmapBytesPerRow;
	
	bitmapBytesPerRow = 4 * MAZE_WID;
	bitmapByteCount = bitmapBytesPerRow * MAZE_HEI;
	
	colorSpace = CGColorSpaceCreateDeviceRGB();

	bitmapData = malloc( bitmapByteCount );
	if( bitmapData == NULL )
	{
		fprintf( stderr, "Memory not alloc" );
		return;
	}
	
	m_buffer = CGBitmapContextCreate(bitmapData, MAZE_WID, MAZE_HEI, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedFirst );
	
	if( m_buffer == nil )
	{
		free( bitmapData );
		fprintf( stderr, "Context not Create" );
		return;
	}
	
	CGColorSpaceRelease( colorSpace );
	
	m_pBuffer = CGBitmapContextGetData( m_buffer );
	m_bufferBound = CGRectMake( 40, 56, MAZE_WID, MAZE_HEI );

}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code.
	CGContextRef context;
	context = UIGraphicsGetCurrentContext();

	CGImageRef image = CGBitmapContextCreateImage( m_buffer );
	CGContextDrawImage( context, m_bufferBound, image );
	CGImageRelease( image );
}


//draw a pixel on the buffer
- (void)drawPixel:(BOOL)dot toX:(int)X toY:(int)Y
{
	unsigned int address = 0;
	address = ( (MAZE_HEI - Y - 1) * MAZE_WID + X ) * 4;
	
	float colorFator = 0xaa;
	if( dot == YES )
	{
		colorFator = 0x22;
	}
	
	((Byte*)m_pBuffer)[address] = 0xff;
	((Byte*)m_pBuffer)[address+1] = colorFator;
	((Byte*)m_pBuffer)[address+2] = colorFator;
	((Byte*)m_pBuffer)[address+3] = colorFator;
}


//draw a block
- (void)drawBlock:(Byte*)data toX:(int)X toY:(int)Y isReverse:(BOOL)reverse
{
	int i,j;
	Byte buff;
	
	for(i=0;i<16;i++)
	{
		for(j=0;j<16;j++)
		{
			buff = data[i*2+j/8];

			if((buff>>(7-(j%8)))&0x01 == 1)
			{
				[self drawPixel:(!reverse) toX:(X+j) toY:(Y+i)];
			}else
			{
				[self drawPixel:reverse toX:(X+j) toY:(Y+i)];
			}
		}
	}
}

- (void)drawBlock:(Byte*)data toX:(int)X toY:(int)Y
{
	[self drawBlock:data toX:X toY:Y isReverse:NO];
}



//erase a block
- (void)eraseBlock:(int)X toY:(int)Y
{
	int i, j;
	
	for(i=0;i<16;i++)
	{
		for(j=0;j<16;j++)
		{
			[self drawPixel:NO toX:(X+i) toY:(Y+j)];
		}
	}	
}


//draw a frame
- (void)drawFrame:(int)left toTop:(int)top toRight:(int)right toBottom:(int)bottom
{
	int i;
 	
 	for(i=left+16;i<right-16;i+=16)
 	{
		[self drawBlock:edgeTop toX:i toY:top];
		[self drawBlock:edgeBottom toX:i toY:(bottom-16)];
 	}
 	
 	for(i=top+16;i<bottom-16;i+=16)
 	{
		[self drawBlock:edgeLeft toX:left toY:i];
		[self drawBlock:edgeRight toX:(right-16) toY:i];
 	}
	
	[self drawBlock:edgeLeftTop toX:left toY:top];
	[self drawBlock:edgeLeftBottom toX:left toY:(bottom-16)];
	[self drawBlock:edgeRightTop toX:(right-16) toY:top];
	[self drawBlock:edgeRightBottom toX:(right-16) toY:(bottom-16)];
}


- (void)drawEdge
{	
	[self drawFrame:160 toTop:0 toRight:224 toBottom:32];
	[self drawFrame:160 toTop:32 toRight:224 toBottom:80];
	[self drawFrame:160 toTop:80 toRight:224 toBottom:128];
	[self drawFrame:165 toTop:85 toRight:219 toBottom:123];
	[self drawFrame:170	toTop:90 toRight:214 toBottom:118];
	[self drawBlock:treasure toX:185 toY:96];
	
	[self drawBlock:shang toX:224 toY:0];
	[self drawBlock:hai toX:224 toY:16];
	[self drawBlock:di toX:224 toY:32];
	[self drawBlock:er toX:224 toY:48];
	[self drawBlock:gong toX:224 toY:64];
	[self drawBlock:ye toX:224 toY:80];
	[self drawBlock:da toX:224 toY:96];
	[self drawBlock:xue toX:224 toY:112];
	
	[self drawBlock:sheng toX:168 toY:8];
	[self drawBlock:jian toX:200 toY:8];
	[self drawBlock:sheng2 toX:168 toY:40];
	[self drawBlock:ming toX:184 toY:40];
	[self drawBlock:zhi toX:200 toY:40];
	[self drawBlock:blank toX:168 toY:56];
	[self drawBlock:blank toX:184 toY:56];
	[self drawBlock:blank toX:200 toY:56];
}

//draw the map
- (void)drawMap
{
	int i;
	int j;
	
	for(i=0;i<10;i++)
	{
		for(j=0;j<8;j++)
		{
			if( map[j+offsetY][i+offsetX] == 1 )
			{
				[self drawBlock:wall toX:(i*16) toY:(j*16)];
			}else
			{
				[self eraseBlock:(i*16) toY:(j*16)];
			}
		}
	}
}


- (void)movLeft
{
	manX--;
	if(map[manY][manX]==0)
	{
		if(manX-offsetX<3)
		{
			offsetX--;
		}
		if(offsetX<0)
		{
			offsetX=0;
		}
		step++;
	}else
	{
		manX++;
	}	
}


- (void)movRight
{
	manX++;
	if(map[manY][manX]==0)
	{
		if(manX-offsetX>6)
		{
			offsetX++;
		}
		if(offsetX>mapWid-10)
		{
			offsetX=mapWid-10;
		}
		step++;
	}else
	{
		manX--;
	}	
}


- (void)movUp
{
	manY--;
	if(map[manY][manX]==0)
	{
		if(manY-offsetY<3)
		{
			offsetY--;
		}
		if(offsetY<0)
		{
			offsetY=0;
		}
		step++;
	}else
	{
		manY++;
	}	
}


- (void)movDown
{
	manY++;
	if(map[manY][manX]==0)
	{
		if(manY-offsetY>4)
		{
			offsetY++;
		}
		if(offsetY>mapHei-8)
		{
			offsetY=mapHei-8;
		}
		step++;
	}else
	{
		manY--;
	}	
}


- (void)drawMan
{
	[self drawBlock:man[manDirection] toX:(manX-offsetX)*16 toY:(manY-offsetY)*16];
}


- (void)drawTreasure
{
	int i;
 	
 	for(i=0;i<9;i++)
 	{
 	 	if(allTreasure[i].beFind==false)
 	 	{
 	 	 	if(allTreasure[i].xpos-offsetX < 10 &&
			   allTreasure[i].xpos-offsetX > 0 &&
			   allTreasure[i].ypos-offsetY > 0 &&
			   allTreasure[i].ypos-offsetY < 8)
 	 	 	{
				[self drawBlock:treasure toX:(allTreasure[i].xpos - offsetX)*16 toY:(allTreasure[i].ypos - offsetY)*16];
 	 	 	}
 	 	}
 	}
}


- (void)updateInfo
{	
	[self drawBlock:number[treasureNum] toX:186 toY:8];
	[self drawBlock:blank toX:170 toY:56];
	[self drawBlock:blank toX:186 toY:56];
	[self drawBlock:blank toX:202 toY:56];
	[self drawBlood:167 toY:60];
}


- (void)drawBlood:(int)X toY:(int)Y
{
	int i;
 	int j;
	int blood=(maxStep-step)/10;
 	for(i=0;i<50;i++)
 	{
 	 	for(j=0;j<10;j++)
 	 	{
 	 	 	if(i<blood)
 	 	 	{
				[self drawPixel:YES toX:X+i toY:Y+j];
 	 		}else
 	 		{
				[self drawPixel:NO toX:X+i toY:Y+j];
 	 		}
 	 	}
 	}	
}


- (void)gotoState:(int)state
{
	m_curStateIndex++;
	m_stateStack[m_curStateIndex] = state;
	gameState = state;
	
	m_stepCnt = 0;
}


- (void)quitToState:(int)state
{
	m_stateStack[m_curStateIndex] = state;
	gameState = state;
	
	m_stepCnt = 0;
}


- (void)popState
{
	m_curStateIndex--;

	m_stepCnt = 0;
	
	if( m_curStateIndex < 0 )
	{
		m_curStateIndex = -1;
		gameState = GAME_STATE_NULL;
		return;
	}

	gameState = m_stateStack[m_curStateIndex];
}


//--------------------------------------- event handler -------------------------------------------

- (IBAction)_onLeftPress:(id)sender
{
	keys[KEY_LEFT] = YES;
}

- (IBAction)_onRightPress:(id)sender
{
	keys[KEY_RIGHT] = YES;
}

- (IBAction)_onUpPress:(id)sender
{
	keys[KEY_UP] = YES;
}

- (IBAction)_onDownPress:(id)sender
{
	keys[KEY_DOWN] = YES;
}

- (IBAction)_onLeftRelease:(id)sender
{
	keys[KEY_LEFT] = NO;
}

- (IBAction)_onRightRelease:(id)sender
{
	keys[KEY_RIGHT] = NO;
}

- (IBAction)_onUpRelease:(id)sender
{
	keys[KEY_UP] = NO;
}

- (IBAction)_onDownRelease:(id)sender
{
	keys[KEY_DOWN] = NO;
}

- (void)dealloc {
    [super dealloc];
}


@end
