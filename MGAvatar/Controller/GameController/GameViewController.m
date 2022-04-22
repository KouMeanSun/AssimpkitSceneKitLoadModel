//
//  GameViewController.m
//  MGAvatar
//
//  Created by Gaomingyang on 2022/4/21.
//

#import "GameViewController.h"
#import <AssimpKit/PostProcessingFlags.h>
#import <AssimpKit/SCNAssimpAnimSettings.h>
#import <AssimpKit/SCNNode+AssimpImport.h>
#import <AssimpKit/SCNScene+AssimpImport.h>

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Plane";
   [self loadDefaultScene];
    //[self loadBobMan];
}

-(void)loadBobMan{
    NSString *docsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES).firstObject;
    NSString *bob = [docsDir stringByAppendingString:@"/Bob.md5mesh"];
    if([[NSFileManager defaultManager] fileExistsAtPath:bob]){
        // load mesh
        SCNAssimpScene *scene = [SCNScene assimpSceneWithURL:[NSURL URLWithString:bob] postProcessFlags:AssimpKit_JoinIdenticalVertices |
                                 AssimpKit_Process_FlipUVs |
                                 AssimpKit_Process_Triangulate error:nil];
        // create and add a camera to the scene
        SCNNode *cameraNode = [SCNNode node];
        cameraNode.camera = [SCNCamera camera];
        [scene.rootNode addChildNode:cameraNode];
        
        // place the camera
        cameraNode.position = SCNVector3Make(0, 0, 15);
        
        // create and add a light to the scene
        SCNNode *lightNode = [SCNNode node];
        lightNode.light = [SCNLight light];
        lightNode.light.type = SCNLightTypeOmni;
        lightNode.position = SCNVector3Make(0, 10, 10);
        [scene.rootNode addChildNode:lightNode];
        
        // create and add an ambient light to the scene
        SCNNode *ambientLightNode = [SCNNode node];
        ambientLightNode.light = [SCNLight light];
        ambientLightNode.light.type = SCNLightTypeAmbient;
        ambientLightNode.light.color = [UIColor darkGrayColor];
        [scene.rootNode addChildNode:ambientLightNode];
        
        // load animation
        NSString *bobAnim = [docsDir stringByAppendingString:@"/Bob.md5anim"];
        [SCNScene assimpSceneWithURL:[NSURL URLWithString:bobAnim]
                    postProcessFlags:AssimpKit_JoinIdenticalVertices |
         AssimpKit_Process_FlipUVs |
         AssimpKit_Process_Triangulate error:nil];
        NSString *bobId = @"Bob-1";
        SCNAssimpAnimSettings *animSetting = [[SCNAssimpAnimSettings alloc] init];
        animSetting.repeatCount = 10;
        SCNScene *anim = [scene animationSceneForKey:bobId];
        [scene.modelScene.rootNode addAnimationScene:anim forKey:bobId withSettings:animSetting];
        // retrieve the SCNView
        SCNView *scnView = (SCNView *)self.view;
        // set the scene to the view
        scnView.scene = scene.modelScene;
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = YES;
        // show statistics such as fps and timing information
        scnView.showsStatistics = YES;
        // config the view
        scnView.backgroundColor = [UIColor blackColor];
        // play
        scnView.playing = YES;
        
    }else{
        NSLog(@"[ERROR]: Add bob assets via iTunes file sharing");
    }
    
}

-(void)loadDefaultScene{
    // create a new scene
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];

    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];

    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 15);

    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];

    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    // retrieve the ship node
    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
    
    // animate the 3d object
   // [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    // retrieve the SCNView
    SCNView *scnView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-84)];
    
    [self.view addSubview:scnView];
    // set the scene to the view
    scnView.scene = scene;
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;
        
    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;

    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
}

- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

@end
