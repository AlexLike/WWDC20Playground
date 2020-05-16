# Wave Lab
**A Swift Playground by Alexander Zank realized during May 2020.**

![](https://raw.githubusercontent.com/AlexLike/WWDC20Playground/Documentation-Assets/github-header.png?token=AHIOBSZSV5DXYNBWHIO2P726ZFYDS)
## Introduction
"Wave Lab" leverages plenty of exciting Apple technologies to provide its viewers with a highly interactive, scientific, and fun learning experience. It teaches about oscillations in one dimension and waves in 3D-space.

## Used Technology
To realize my idea, I've utilized many of Apple's powerful features and frameworks:
- First, because its view architecture allows for maximum flexibility while preserving full adaptivity, SwiftUI has been employed as the primary user interface system. Prototyping is a breeze and interactive content, the diagram switcher, for instance, behaves more predictably because of its state paradigm. Since splitting up views into smaller and more manageable chunks comes with hardly any performance penalty, components like Grid, LabeledArrow, and Header simplified all root views and significantly boosted bug-fixing sessions.
- Second, to realize mathematically based and timed 2D-animations, an interface between QuartzCore's CADisplayLink and SwiftUI's view system was built using Combine's powerful data flow capabilities. As a result, the user-interruptible single oscillator simulation runs buttery smooth, and the live diagrams provide valuable data insight in real-time.
- Third, SceneKit's high performance, convincing 3D-graphics, and broad compatibility with other platform frameworks, made it an obvious choice for the wave simulation. Because the renderer must calculate the current position of every oscillator's SCNNode for each frame, an enormous amount of computations need to occur. To speed up distance calculations, algebraic operations, and trigonometry, vDSP and vForce's deeply optimized code was accessed using Accelerate's Swift interface. This frequently results in 20 or more frames extra per second when the user places multiple waves.
- Fourth, rounding up the experience on iPad, is the user's ability to explore waves in the real world, be it on their terrace, in their living room, or on their courtyard, using ARKit. "Wave Lab" uses ARKit's plane anchors to continuously update its perception of the world and places the simulation right in front of the experimenter, so they can move comfortably around the scene and explore various perspectives.

All in all, my Swift playground demonstrates how one can use many Apple technologies to create a fun and interactive learning experience, that everyone can share and play at their own pace.

## Installation
To experience Wave Lab yourself, download the zipped .playgroundbook file in this repository, and open it using Swift Playgrounds 3.3 or above for macOS or iPadOS. If this has helped you in any way, feel free to hit me up on Twitter ;D.
