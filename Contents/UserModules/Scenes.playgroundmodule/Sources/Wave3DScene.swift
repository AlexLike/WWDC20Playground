/* 
    Wave Lab - Wave 3D Scene
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import Colors
import Models
import SceneKit
import Accelerate

/// A scene, which contains a given number of oscillator nodes on the x-z-plane.
public class Wave3DScene: SCNScene {
    /// A dictionary containing each oscillator (and with it, its nodes).
    private var oscillators = [Oscillator3D]()
    /// An array of all waves currently active.
    private var waves = [Wave3D]()
    /// The current time, updated by the renderer.
    public var currentTime = TimeInterval()
    /// A node which contains all oscillator nodes, especially useful for positioning the scene in AR.
    public var contentNode = SCNNode()
    
    override internal init() {
        super.init()
    }
    
    public convenience init(xAmount: Int, zAmount: Int, centerDistance: Float, radius: CGFloat) {
        self.init()
        generateOscillators(xAmount: xAmount, zAmount: zAmount, centerDistance: centerDistance, radius: radius)
        rootNode.addChildNode(contentNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Stop! You're not supposed to initialize this way, smh...")
    }
    
    // MARK: - Shared Methods
    
    public func generateOscillators(xAmount: Int, zAmount: Int, centerDistance: Float, radius: CGFloat) {
        // Configure aesthetics.
        background.contents = generateSkyboxAssets()
        let sphereGeometry = SCNSphere(radius: radius)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.gray
        sphereGeometry.firstMaterial?.lightingModel = .lambert
        // Generate oscillators and add nodes to scene.
        oscillators = {
            var _oscillators = [Oscillator3D]()
            let xOrigin = -Float(xAmount) * centerDistance / 2
            let zOrigin = -Float(zAmount) * centerDistance / 2
            for thisX in 1...xAmount {
                for thisZ in 1...zAmount {
                    let node = SCNNode(geometry: sphereGeometry)
                    node.position = SCNVector3(
                        xOrigin + Float(thisX) * centerDistance,
                        0,
                        zOrigin + Float(thisZ) * centerDistance
                    )
                    _oscillators.append(Oscillator3D(node: node))
                    contentNode.addChildNode(node)
                }
            }
            return _oscillators
        }()
    }
    
    public func addWave(sourceNode: SCNNode, wave: Wave) {
        // Get the oscillator object and make sure that there's no similar wave already.
        guard let source = oscillators.first(where: { $0.node == sourceNode }),
            !waves.contains(where: { $0.source == source }) else { return }
        source.node.geometry = source.node.geometry?.copy() as? SCNGeometry
        source.node.geometry?.firstMaterial = source.node.geometry?.firstMaterial?.copy() as? SCNMaterial
        source.node.geometry?.firstMaterial?.diffuse.contents = Colors.vividBlueLegacy
        // Contruct and add this wave.
        waves.append(
            Wave3D(
                source: source,
                model: wave,
                t₀: currentTime
            )
        )
        updateDistances()
    }
    
    public func removeWave(sourceNode: SCNNode) {
        waves.removeAll { $0.source.node == sourceNode }
        updateDistances()
    }
    
    public func updateElongations() {
        oscillators.forEach { oscillator in
            let enumeratedWaves = waves.enumerated()
            let innerValues: [Float] = enumeratedWaves.map { (index, wave) in
                let t = (currentTime - wave.t₀)
                guard oscillator.distances.indices.contains(index) else { return 0 }
                let distance = oscillator.distances[index]
                guard wave.model.c * Float(t) >= distance else { return 0 }
                return Float(wave.model.oscillation.ω * t) - 2 * .pi * oscillator.distances[index] / wave.model.λ
            }
            let sineValues = vForce.sin(innerValues)
            let superposedYValues: [Float] = enumeratedWaves.map { (index, wave) in
                guard sineValues.indices.contains(index) else { return 0 }
                return Float(wave.model.oscillation.ŷ) * sineValues[index]
            }
            let actualYValue = vDSP.sum(superposedYValues)
            oscillator.node.position.y = actualYValue
        }
    }
    
    
    // MARK: - Private Methods
    
    private func updateDistances() {
        DispatchQueue.global(qos: .userInitiated).async {
            for (index, oscillator) in self.oscillators.enumerated() {
                let oscillatorOrigin = [oscillator.node.position.x, oscillator.node.position.z]
                let waveOrigins = self.waves.map { [$0.source.node.position.x, $0.source.node.position.z] }
                let squaredDistances = waveOrigins.map { vDSP.distanceSquared($0, oscillatorOrigin) }
                self.oscillators[index].distances = vForce.sqrt(squaredDistances)
            }
        }
    }
    
    
    // MARK: - Non-AR Methods
    
    private func generateSkyboxAssets() -> CGImage? {
        UIGraphicsBeginImageContext(CGSize(width: 600, height: 300))
        let colors = [UIColor.white.cgColor, CGColor(srgbRed: 0.85, green: 0.85, blue: 0.85, alpha: 1)] as CFArray
        let locations: [CGFloat] = [0, 1]
        guard let context = UIGraphicsGetCurrentContext(),
            let gradient = CGGradient(
                colorsSpace: context.colorSpace,
                colors: colors,
                locations: locations
            ) else { return nil }
        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: 3 * context.height / 4),
            end: CGPoint(x: 0, y: context.height),
            options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
        )
        guard let image = context.makeImage() else { return nil }
        return image
    }
    
}
