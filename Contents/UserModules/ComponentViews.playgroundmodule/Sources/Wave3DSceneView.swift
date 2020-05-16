/* 
    Wave Lab - Wave 3D Scene View
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import Models
import Scenes
import SwiftUI
import SceneKit

/// A view hosting a 3D-experience for testing waves.
public struct Wave3DSceneView: UIViewControllerRepresentable {
    /// The interactive scene about to be displayed.
    let scene: Wave3DScene
    /// The model describing the waves that are placed on tap.
    let wave: Wave
    
    /// Initializes a new view hosting a 3D-experience for testing waves.
    /// - Parameter wave: The model describing the waves that are placed on tap.
    /// - Parameter scene: The hosted scene.
    public init(wave: Wave, scene: Wave3DScene) {
        self.wave = wave
        self.scene = scene
    }

    public func makeUIViewController(context: Context) -> Wave3DSceneViewController {
        Wave3DSceneViewController(wave: wave, scene: scene)
    }
    
    public func updateUIViewController(_ uiViewController: Wave3DSceneViewController, context: Context) {
        return
    }
    
    public func makeCoordinator() -> () {
        Coordinator()
    }
    
}

public class Wave3DSceneViewController: UIViewController, SCNSceneRendererDelegate {
    /// The interactive scene about to be displayed.
    let scene: Wave3DScene
    /// The model describing the waves that are placed on tap.
    let wave: Wave
    
    /// Initializes a new view controller hosting a 3D-experience for testing waves.
    /// - Parameter wave: The model describing the waves that are placed on tap.
    /// - Parameter scene: The hosted scene.
    public init(wave: Wave, scene: Wave3DScene) {
        self.wave = wave
        self.scene = scene
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Stop! You're not supposed to initialize this way, smh...")
    }
    
    /// This controller's main view, which displays the 3D-scene.
    lazy var sceneView: SCNView = {
        let _sceneView = SCNView()
        _sceneView.scene = scene
        _sceneView.autoenablesDefaultLighting = true
        _sceneView.allowsCameraControl = true
        _sceneView.rendersContinuously = true
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap(_:))
        )
        tapGestureRecognizer.numberOfTapsRequired = 1
        _sceneView.addGestureRecognizer(tapGestureRecognizer)
        return _sceneView
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view = sceneView
        sceneView.delegate = self
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        // Add waves.
        let location = tap.location(in: sceneView)
        let hitResults = sceneView.hitTest(
            location,
            options: [
                SCNHitTestOption.boundingBoxOnly: true
            ]
        )
        if let node = hitResults.first?.node,
            let scene = sceneView.scene as? Wave3DScene {
            scene.addWave(
                sourceNode: node,
                wave: self.wave
            )
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        scene.currentTime = time
        scene.updateElongations()
    }
}
