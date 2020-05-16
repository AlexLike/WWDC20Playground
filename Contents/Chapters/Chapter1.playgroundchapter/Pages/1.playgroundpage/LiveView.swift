
import Models
import Pages
import PlaygroundSupport

// Default oscillation
let myOscillation = Oscillation(
    ŷ: 0.02,
    f: 0.5
)

// Start live view
PlaygroundPage.current.setLiveView(SingleOscillatorPage(oscillation: myOscillation))