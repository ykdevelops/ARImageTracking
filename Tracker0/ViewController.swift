//
//  ViewController.swift
//  ImageTrackingDemo
//
//  Created by Youssef Khalil Feb-26-2021
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
                                                                                // Protocol provides methods you can implement to mediate the automatic synchronization of SceneKit content with an AR session.
    @IBOutlet var sceneView: ARSCNView!
                                                        // A view that blends virtual 3D content from SceneKit into your augmented reality experience.

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/card.scn")!
        // Set the scene to the view
        sceneView.scene = scene
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration() // A configuration that tracks known images using the rear-facing camera.
        // Try to get a reference image from the Assets.xcassets / AR Resources
        guard let arReferenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        // Set the configuration trackingImage to the image saved in the AR Resources
        configuration.trackingImages = arReferenceImages
        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // An anchor for a known image that ARKit detects in the physical environment.
        guard anchor is ARImageAnchor else { return }
        // Create a reference that holds the childNode of our sceneView
        guard let card = sceneView.scene.rootNode.childNode(withName: "card", recursively: false) else { return }
        // Remove the content
        card.removeFromParentNode()
        // Add the card to the node
        node.addChildNode(card)
        
        //Show the video
        card.isHidden = false
        
        // Set the video link
        let videoURL = Bundle.main.url(forResource: "wendysCommercial", withExtension: "mp4")!
        // Set the video player
        let videoPlayer = AVPlayer(url: videoURL)
        // Set the videoScene
        let videoScene = SKScene(size: CGSize(width: 720.0, height: 1280.0))
        // Set the videoNode
        let videoNode = SKVideoNode(avPlayer: videoPlayer)
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode.size = videoScene.size
        videoNode.yScale = -1
        videoNode.play()
        // Add the video the the Scene
        videoScene.addChild(videoNode)
        
        // Make the video a childNode of the card
        guard let video = card.childNode(withName: "video", recursively: true) else { return }
        video.geometry?.firstMaterial?.diffuse.contents = videoScene
    }

}
