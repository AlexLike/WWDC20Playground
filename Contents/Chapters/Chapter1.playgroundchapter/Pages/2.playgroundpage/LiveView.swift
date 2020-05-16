
import Models
import Pages
import PlaygroundSupport

// Default wave
let myWave = Wave(oscillation: Oscillation(ŷ: 0.3, f: 0.6), c: 0.9)

// Start live view
PlaygroundPage.current.setLiveView(Wave3DPage(wave: myWave, xAmount: 30, zAmount: 30, centerDistance: 0.06, radius: 0.02))