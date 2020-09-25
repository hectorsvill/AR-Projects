//
//  ContentView.swift
//  ModelPickerApp
//
//  Created by Hector Villasano on 9/25/20.
//

import SwiftUI
import RealityKit

// reality kit uses sdc format.

struct ContentView : View {
    var body: some View {
        
        Text("Hector")
        
//        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
