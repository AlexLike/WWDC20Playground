/* 
    Wave Lab - Wave 3D AR-Scene View
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

#if canImport(ARKit)

import Models
import Scenes
import ManagedObjects
import SwiftUI
import ARKit

public struct Wave3DARSceneView: UIViewControllerRepresentable {
    /// The interactive scene about to be displayed.
    let scene: Wave3DARScene
    /// The model describing the waves that are placed on tap.
    let wave: Wave
    
    /// Initializes a new view hosting an AR-experience for testing waves.
    /// - Parameter wave: The model describing the waves that are placed on tap.
    /// - Parameter scene: The hosted scene.
    public init(wave: Wave, scene: Wave3DARScene) {
        self.wave = wave
        self.scene = scene
    }

    public func makeUIViewController(context: Context) -> Wave3DARSceneViewController {
        Wave3DARSceneViewController(wave: wave, scene: scene)
    }

    public func updateUIViewController(_ uiViewController: Wave3DARSceneViewController, context: Context) {
        return
    }
    
    public func makeCoordinator() -> () {
        Coordinator()
    }
    
}

public class Wave3DARSceneViewController: UIViewController, ARSCNViewDelegate {
    /// The interactive scene about to be displayed.
    let scene: Wave3DARScene
    /// The model describing the waves that are placed on tap.
    let wave: Wave
    
    /// Initializes a new view hosting an AR-experience for testing waves.
    /// - Parameter wave: The model describing the waves that are placed on tap.
    /// - Parameter scene: The hosted scene.
    public init(wave: Wave, scene: Wave3DARScene) {
        self.wave = wave
        self.scene = scene
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Stop! You're not supposed to initialize this way, smh...")
    }
    
    /// This controller's main view, which displays the AR scene.
    lazy var arView: ARSCNView = {
        let _arView = ARSCNView()
        _arView.scene = scene
        _arView.autoenablesDefaultLighting = true
        _arView.rendersContinuously = true
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap(_:))
        )
        tapGestureRecognizer.numberOfTapsRequired = 1
        _arView.addGestureRecognizer(tapGestureRecognizer)
        return _arView
    }()
    
    /// A value that stores whether the interactive scene is placed or not.
    var isContentPlaced = false {
        didSet { if isContentPlaced { placeInstructions.isHidden = true } }
    }
    
    /// A value that stores whether the tracking indicator node has been placed or not.
    var isTrackingIndicatorPlaced = false
    
    /// A coaching view, which may be displayed on older devices during ARKit calibration.
    lazy var coachingView: ARCoachingOverlayView = {
        let _coachingView = ARCoachingOverlayView()
        _coachingView.session = self.arView.session
        return _coachingView
    }()
    
    lazy var backButton: UIButton = {
        let _backButton = UIButton()
        _backButton.tintColor = .white
        _backButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        _backButton.setImage(UIImage(systemName: "escape"), for: .normal)
        _backButton.contentEdgeInsets.left = 5
        _backButton.imageEdgeInsets.left = -5
        _backButton.setTitle("Exit AR", for: .normal)
        _backButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        return _backButton
    }()
    
    lazy var placeInstructions: UILabel = {
        let _placeInstructions = UILabel()
        _placeInstructions.text = "In an area with sufficient room, tap to place the oscillator plane."
        _placeInstructions.textColor = .white
        _placeInstructions.font = UIFont.preferredFont(forTextStyle: .caption1)
        return _placeInstructions
    }()
    
    var viewCenter = CGPoint()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(arView)
        arView.delegate = self
        arView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // Add a coaching view for older AR-devices.
        view.addSubview(coachingView)
        coachingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coachingView.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 12)
        ])
        
        view.addSubview(placeInstructions)
        placeInstructions.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeInstructions.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeInstructions.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -12)
        ])
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let arConfig = ARWorldTrackingConfiguration()
        // Buggy in full-screen (default value anyway!)
        // arConfig.planeDetection = .horizontal
        // Unsupported in Swift Playgrounds
        // arConfig.frameSemantics.insert(.personSegmentationWithDepth)
        arView.session.run(arConfig)
    }
    
    override public func viewDidLayoutSubviews() {
        viewCenter = view.center
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    override public var prefersStatusBarHidden: Bool { true }
    
    public func getViewportCenterInWorld() -> SCNVector3? {
        guard let hitResult = arView.hitTest(
            viewCenter,
            types: [
                .existingPlaneUsingGeometry,
                .existingPlaneUsingExtent,
                .estimatedHorizontalPlane
        ]).first else { return nil }
        let viewportCenterWorldTransform = SCNMatrix4(hitResult.worldTransform)
        return SCNVector3(viewportCenterWorldTransform.m41, viewportCenterWorldTransform.m42, viewportCenterWorldTransform.m43)
    }
    
    @objc func exit() {
        FullscreenPresenter.shared.dismiss()
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        if !isContentPlaced {
            // Place the interactive scene just below eyesight and in the viewing angle.
            guard let centerPosition = getViewportCenterInWorld(),
                let camera = arView.session.currentFrame?.camera else { return }
            let cameraPerspective = SCNMatrix4(camera.transform)
            let angle = camera.eulerAngles.y
            scene.placeContent(at: centerPosition, viewingFrom: cameraPerspective, cameraAngle: angle)
            isContentPlaced = true
            scene.trackingIndicator.removeFromParentNode()
            isTrackingIndicatorPlaced = false
            return
        }
        // Add waves.
        let location = tap.location(in: arView)
        let hitResults = arView.hitTest(
            location,
            options: [
                SCNHitTestOption.boundingBoxOnly: true
            ]
        )
        if let node = hitResults.first?.node {
            scene.addWave(
                sourceNode: node,
                wave: self.wave
            )
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        scene.currentTime = time
        
        if !isContentPlaced {
            // Display the tracking indicator in the middle of the viewport on a plain.
            guard let centerPosition = getViewportCenterInWorld() else { return }
            scene.trackingIndicator.position = centerPosition
            if !isTrackingIndicatorPlaced { scene.rootNode.addChildNode(scene.trackingIndicator) }
            return
        }
        
        scene.updateElongations()
    }
}

#endif
