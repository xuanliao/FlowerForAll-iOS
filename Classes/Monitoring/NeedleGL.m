//
//  NeedleGL.m
//
//  Copyright fondation Defitech 20011. All rights reserved.
//


/*
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "NeedleGL.h"
#import "FlowerController.h"
#import "ParametersManager.h"

#define USE_DEPTH_BUFFER 1
#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)

// A class extension to declare private methods
@interface NeedleGL ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation NeedleGL

@synthesize context;
@synthesize animationTimer;
//@synthesize animationInterval;

// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        // ? retina Display
        if ([self respondsToSelector:@selector(contentScaleFactor)])
        {
            self.contentScaleFactor = [[UIScreen mainScreen] scale];
            eaglLayer.contentsScale = [[UIScreen mainScreen] scale];
        }

        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification 
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification 
                                                   object:nil];
        
        animationInterval = 1.0 / 60.0;
		[self setupView];
		[self startAnimation];
    }
    
    return self;
}


- (void)applicationWillResignActive:(NSNotification *)notification {
    [self stopAnimation];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self startAnimation];
}

const GLfloat needleCenterX = 0.0f, needleCenterY = -1.0f, needleCenterZ = 0.0f;

- (void)setupView {
	
    const GLfloat zNear = 0.1, zFar = 1000.0, fieldOfView = 35.0;
    
    GLfloat size;

    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);
	
	// The size of the UIView
    CGRect rect = self.bounds;
    glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / (rect.size.width / rect.size.height), zNear, zFar);
    glViewport(0, 0, rect.size.width, rect.size.height);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
      
}

- (void)drawLine:(float)x1 y1:(float)y1  z1:(float)z1 x2:(float)x2 y2:(float)y2 z2:(float)z2 {
	const GLfloat lineVertices[] = {
        x1, y1, z1,                  
        x2, y2, z2,                  
    };
//	NSLog(@"line %f,%f,%f %f,%f,%f",lineVertices[0],lineVertices[1],lineVertices[2],lineVertices[3],lineVertices[4],lineVertices[5]);	
	
	// line
	
	glVertexPointer(3, GL_FLOAT, 0, lineVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glDrawArrays(GL_LINES, 0, 2);
	
}



- (void)drawBox:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2 z:(float)z {
	const GLfloat quadVertices[] = {
        x1, y1, z,
        x1, y2, z,
        x2, y2, z,
        x2, y1, z
    };
    glVertexPointer(3, GL_FLOAT, 0, quadVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
}



- (void)drawView {
    FLAPIX* flapix = [FlowerController currentFlapix];
    if (flapix == nil) return;
    
	    
	//""""""""""""""""""" Logic code """""""""""""""""""/
    
    
    static float angle_actual = 0.1f;         // effective rotation angle in degrees
    static float angle_toreach = 0.0f;         // current angle
    static float angle_previous = 0.0f;           // previous angle
    static float angle_freqMin = 0.0f;
    static float angle_freqMax = 0.0f;
    static float angle_freqMin_previous = 0.0f;
    static float angle_freqMax_previous = 0.0f;
    static float speed = 0.0f;          // rotation speed
    
    
    
    angle_freqMin = [NeedleGL frequencyToAngle:([flapix frequenceTarget] - [flapix frequenceTolerance])]*180;
    angle_freqMax = [NeedleGL frequencyToAngle:([flapix frequenceTarget] + [flapix frequenceTolerance])]*180;
    angle_toreach = [NeedleGL frequencyToAngle:flapix.frequency]*180;
    
    if (fabs(angle_toreach - angle_actual) < 2  && angle_freqMin == angle_freqMin_previous && angle_freqMax == angle_freqMax_previous) {
        //nothing to do
       // return;
    }
    angle_freqMin_previous = angle_freqMin;
    angle_freqMax_previous = angle_freqMax;
    
    
    //"""""""""""""""""" Drawing code """"""""""""""""""""""/
    
    
    [EAGLContext setCurrentContext:context];    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);

    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // --- Blowing gauge
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glTranslatef(needleCenterX,needleCenterY,needleCenterZ);
    
    
    //glRotatef(angle_freqMax, 0.0f, 0.0f, -1.0f);
    static float hPos = 0;
    static float hSpeed = 0.01;
    static BOOL goal = NO;
    float h = [flapix currentBlowPercent];
    if (! flapix.blowing) h = 0;
    if (h < 1 && (h > hPos)) goal = NO; // we keep goal value to descend the gauge
    if (h > 1) goal = YES;
    
    if (goal) {
        glColor4f(0.9f,  0.7f, 0.0f, 1.0f);
    } else {
        glColor4f(0.1f,  0.5f, 0.3f, 1.0f);
    }
    
    hSpeed = (h < hPos) ? 0.2 : 0.1;
    
    hPos = hPos + (h - hPos ) * hSpeed;
    
	[self drawBox:-1.5 y1:-0.5 x2:1.5 y2:(hPos*2.5) - 0.5 z:-5.001];
    
    // gauge line
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glTranslatef(needleCenterX,needleCenterY,needleCenterZ);
    glColor4f(1.0f, 9.0f, 0.0f, 1.0f);
    [self drawLine:-0.5 y1:2.0 z1:-5.002 x2:0.5  y2:2.0  z2:-5.002];
    
    // --- Needle
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glTranslatef(needleCenterX,needleCenterY,needleCenterZ);
    
    // Def needle
	const GLfloat quadVertices[] = {
        0.0, 2.0, -5.0,                    // head
        0.5, 0.0, -5.0,                    // left
        0.0, -0.5, -5.0,                      // queue
        -0.5, 0.0, -5.0                     // right
    };

    
    if(!flapix.blowing) {
        
        glColor4f(0.2f, 0.2f, 0.5f+[flapix lastlevel]/2, 1.0f);
    } else { 
        speed = fabs((angle_toreach - angle_previous) / 10);
       // NSLog(@"speed = %f \n", speed);
    
        if(angle_toreach > angle_previous) {
            angle_actual = angle_previous + speed;
        } else {
            angle_actual = angle_previous - speed;
        }
        
        
        if ((angle_freqMax > angle_actual) && (angle_freqMin < angle_actual)) { // Good
            glColor4f(0.1f,  0.9f, 0.1f, 1.0f);
        } else { // Bad
            glColor4f(1.0f, 0.0f, 0.0f, 1.0f);
        }
        
        angle_previous = angle_actual;
    }
    glRotatef(angle_actual, 0.0f, 0.0f, -1.0f);
    
	
	glVertexPointer(3, GL_FLOAT, 0, quadVertices);
	
	glEnableClientState(GL_VERTEX_ARRAY);
    
    if ([flapix running])
        glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    
    
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
     glTranslatef(needleCenterX,needleCenterY,needleCenterZ);
    
    
    glRotatef(angle_freqMax, 0.0f, 0.0f, -1.0f);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	[self drawLine:0.0 y1:0.0 z1:-4.999 x2:0.0  y2:4.0  z2:-4.999];

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(needleCenterX,needleCenterY,needleCenterZ);
    
    glRotatef(angle_freqMin, 0.0f, 0.0f, -1.0f);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
	[self drawLine:0.0 y1:0.0 z1:-4.999 x2:0.0  y2:4.0  z2:-4.999];
    
	
	//""""""""""""""""" Fin du nouveau code """""""""""""""""""
	
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
    self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}

- (NSTimeInterval)animationInterval {
    return animationInterval;
}

- (void)setAnimationInterval:(NSTimeInterval)interval {
    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}

- (void)checkGLError:(BOOL)visibleCheck {
    GLenum error = glGetError();
    
    switch (error) {
        case GL_INVALID_ENUM:
            NSLog(@"GL Error: Enum argument is out of range");
            break;
        case GL_INVALID_VALUE:
            NSLog(@"GL Error: Numeric value is out of range");
            break;
        case GL_INVALID_OPERATION:
            NSLog(@"GL Error: Operation illegal in current state");
            break;
        case GL_STACK_OVERFLOW:
            NSLog(@"GL Error: Command would cause a stack overflow");
            break;
        case GL_STACK_UNDERFLOW:
            NSLog(@"GL Error: Command would cause a stack underflow");
            break;
        case GL_OUT_OF_MEMORY:
            NSLog(@"GL Error: Not enough memory to execute command");
            break;
        case GL_NO_ERROR:
            if (visibleCheck) {
                NSLog(@"No GL Error");
            }
            break;
        default:
            NSLog(@"Unknown GL Error");
            break;
    }
}

+(float)frequencyToAngle:(double)freq {
    float longest = ([[FlowerController currentFlapix] frequenceMax] - [[FlowerController currentFlapix] frequenceTarget]) >
    ([[FlowerController currentFlapix] frequenceTarget] - [[FlowerController currentFlapix] frequenceMin]) ?
    ([[FlowerController currentFlapix] frequenceMax] - [[FlowerController currentFlapix] frequenceTarget]) :
    ([[FlowerController currentFlapix] frequenceTarget] - [[FlowerController currentFlapix] frequenceMin]);
    
    return (freq - [[FlowerController currentFlapix] frequenceTarget]) / (2 * longest ) ;
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touched");
    [FlowerController showNav];
}


- (void)dealloc {
    
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

@end
*/