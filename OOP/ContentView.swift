//
//  ContentView.swift
//  OOP
//
//  Created by Миша Перевозчиков on 05.05.2022.
//

import SwiftUI

//Creating this class we have an ability to create an extra space for expanding our possibilities with an Instrument
class Music {
    let notes: [String]
    
    init(notes: [String]) {
        self.notes = notes
    }
    
    func prepared() -> String  {
        return notes.joined(separator: " ")
    }
}

//this is an example of Encapsulation. The type of the class describe data(stored properties) and it's behaviour (methods).
class Instrument {
    
    let brand: String
    
    init(brand: String) {
        self.brand = brand
    }
    
    //this method will be run only if we will request it in a child class. Also we should change this method in child class to use it without fatal error.
    func tune() -> String {
        fatalError("Implement this method for \(brand)")
    }
    
    func play(_ music: Music) -> String {
        return music.prepared()
    }
    
    //
    func perform(_ music: Music) {
        print(tune())
        print(play(music))
    }
}

// MARK: Inheritance of the Instrument class it's properties and methods.
class Piano: Instrument {
    let hasPedal: Bool
    
    static let keys = 32
    static let blackKeys = 12
    
    init(brand: String, hasPedal: Bool = false) {
        self.hasPedal = hasPedal
        //this initializer cares about parent class properties initialisation
        super.init(brand: brand)
    }
    
    // override method to make it more useful in particular case
    override func tune() -> String {
        return "Piano standard tuning for \(brand)."
    }
    //Here we override parent method to call original parent method with super. keyword and get notes
    override func play(_ music: Music) -> String {

        return play(music, usingPedals: hasPedal)
    }
    
    //
    //MARK: Overloading
    //we overload play method and it allow us to use to kind of this methods, but we should be careful, because Instrument.perform() uses only override play(_ :)
    func play(_ music: Music, usingPedals: Bool) -> String {
        let preparedNotes = super.play(music)
        
        if hasPedal && usingPedals {
            return "Play piano notes \(preparedNotes) with pedals."
        } else {
            return "Play piano notes \(preparedNotes) without pedals."
        }
    }
}

// MARK: Instances

let piano = Piano(brand: "Lomi", hasPedal: true)
let music = Music(notes: ["C", "L", "C"])

let composition = piano.play(music, usingPedals: false)

let composition2 = piano.play(music)


// MARK: Abstract class
// This will be kind a main class above such explicit guitar. It holds just one property, that should be in each Guitar child. All method of instruments are also available here . tune () и play (_ : )
class Guitar: Instrument {
    let stringGauge: String
    
    init(brand: String, stringGauge: String) {
        self.stringGauge = stringGauge
        super.init(brand: brand)
    }
}

// MARK: Specific Guitars
//
class AcousticGuitar: Guitar {
    //There will be just static properties. Thats why we didn't need an initializer. Because an instance of this class will be constant and will never be changed.
    static let numberOfStrings = 6
    static let fretCount = 20
    
    override func tune() -> String {
        return "Tune \(brand) acoustic with E A D G B E"
    }
    
    override func play(_ music: Music) -> String {
            let preparedNotes = super.play(music)
            return "Play folk tune on frets \(preparedNotes)."
        }
}

// create a specific guitar and play on it
let rolandGuitar = AcousticGuitar(brand: "Roland", stringGauge: "Light")
let guitarComposition = rolandGuitar.play(music)


//MARK: Private access level
// _volume is available only inside of the Amplifier class, and will be hidden from outer users
// isOn property will be available to external users just for Reading only
//PlugIn() и unplug() affect on volume
//

class Amplifier {
    private var _volume: Int
    private(set) var isOn: Bool
    
    init() {
            isOn = false
            _volume = 0
        }
    
    func plugIn() {
           isOn = true
       }
    
    func unplug() {
            isOn = false
        }
    
    var volume: Int {
        get {
            return isOn ? _volume : 0
        }
        set {
            _volume = min(max(newValue, 0), 10)
        }
    }
}

//MARK: Composition
//

class ElectricGuitar: Guitar {
    let amplifier: Amplifier
    
    init(brand: String, stringGauge: String = "light", amplifier: Amplifier) {
        self.amplifier = amplifier
        super.init(brand: brand, stringGauge: stringGauge)
    }
    
    override func tune() -> String {
        amplifier.plugIn()
        amplifier.volume = 5
        return "Tune \(brand) bass with E A D G"
    }
    override func play(_ music: Music) -> String {
        let preparedNotes = super.play(music)
        return "Play bass line \(preparedNotes) at volume \(amplifier.volume)."
        
    }
}

class BassGuitar: Guitar  {
    let amplifier: Amplifier
   
    init(brand: String, stringGauge: String = "heavy", amplifier: Amplifier) {
        self.amplifier = amplifier
        super.init(brand: brand, stringGauge: stringGauge)
    }

    override func tune() -> String {
        amplifier.plugIn()
        return "Tune \(brand) bass with E A D G"
    }

    override func play(_ music: Music) -> String {
            let preparedNotes = super.play(music)
            return "Play bass line \(preparedNotes) at volume \(amplifier.volume)."
    }
}

let amplifier = Amplifier()
let acousticGuitar = AcousticGuitar(brand: "Aloha", stringGauge: "light")
let electricGuitar = ElectricGuitar(brand: "Gibson",
                    stringGauge: "medium",
                        amplifier: amplifier)


let bassGuitar = BassGuitar(brand: "Fender",
                stringGauge: "heavy",
                 amplifier: amplifier)

//MARK: Polymorphism
//Allow us use different object through one Intrface
class Band  {
    let instruments: [Instrument]

    init(instruments: [Instrument]) {
        self.instruments = instruments
    }

    func perform(_ music: Music) {
        for instrument in instruments {
        instrument.perform(music)
        }
    }
}
// we define an array of different instruments
let instruments = [piano, acousticGuitar,
                electricGuitar, bassGuitar]
// Create a band with instruments ad make a concert
let band = Band(instruments: instruments)
//band.perform(music)


//MARK: Composition and Aggregation

class Engine {
    let power = 100
    
    func start() {
        print("Engine is on")
    }
}

class Wheel {
    let radius = 10
    
    func rotate() {
        print("wheels is rotating")
    }
}

class AirFreshener {
    let smell = "Pine"
}
//Composition
//Here we compose different parts of a car in the whole Car class
class Car {
    let engine: Engine
    let wheels: [Wheel]
    let airFreshener: AirFreshener
    
    init(airFreshener: AirFreshener) {
        //Aggregation
        self.airFreshener = airFreshener
        
        //Composition
        self.engine = Engine()
        var wheelsContainer = [Wheel]()
        for _ in 0..<4 {
            wheelsContainer.append(Wheel())
        }
        self.wheels = wheelsContainer
    }
    
    func drive() {
        engine.start()
        
        for wheel in wheels {
            wheel.rotate()
        }
        
        print("The car is moving")
    }
}


struct ContentView: View {
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
