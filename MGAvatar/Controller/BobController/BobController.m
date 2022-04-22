//
//  BobController.m
//  MGAvatar
//
//  Created by Gaomingyang on 2022/4/21.
//

#import "BobController.h"
#import <SceneKit/SceneKit.h>
#import <AssimpKit/PostProcessingFlags.h>
#import <AssimpKit/SCNAssimpAnimSettings.h>
#import <AssimpKit/SCNNode+AssimpImport.h>
#import <AssimpKit/SCNScene+AssimpImport.h>

@interface BobController ()

@end

@implementation BobController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BobMan";
    [self loadBobMan];
}

-(void)loadBobMan{
    NSURL *bobUrl = [[NSBundle mainBundle] URLForResource:@"Bob" withExtension:@".md5mesh"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:bobUrl.path]){
        // load mesh
        NSError *error = nil;
        SCNAssimpScene *scene = [SCNScene assimpSceneWithURL:bobUrl postProcessFlags:AssimpKit_JoinIdenticalVertices |
                                 AssimpKit_Process_FlipUVs |
                                 AssimpKit_Process_Triangulate error:&error];
        [self showErrorIfNeeded:error];
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
        NSURL *bobAnimUrl = [[NSBundle mainBundle] URLForResource:@"Bob" withExtension:@".md5anim"];
        [SCNScene assimpSceneWithURL:bobAnimUrl
                    postProcessFlags:AssimpKit_JoinIdenticalVertices |
         AssimpKit_Process_FlipUVs |
         AssimpKit_Process_Triangulate error:nil];
        NSString *bobId = @"Bob-1";
        SCNAssimpAnimSettings *animSetting = [[SCNAssimpAnimSettings alloc] init];
        animSetting.repeatCount = INT_MAX;
        SCNScene *anim = [scene animationSceneForKey:bobId];
        [scene.modelScene.rootNode addAnimationScene:anim forKey:bobId withSettings:animSetting];
        // retrieve the SCNView
        SCNView *scnView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-84)];
        [self.view addSubview:scnView];
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

- (void)showErrorIfNeeded:(NSError *)error
{
    if (!error.localizedDescription.length)
    {
        return;
    }
    
    UIAlertController *vc = [UIAlertController
                             alertControllerWithTitle:@"Error"
                             message:error.localizedDescription
                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * _Nonnull action) {}];
    [vc addAction:action];
    
    [UIApplication.sharedApplication.keyWindow.rootViewController
     presentViewController:vc
     animated:true
     completion:nil];
}


@end
