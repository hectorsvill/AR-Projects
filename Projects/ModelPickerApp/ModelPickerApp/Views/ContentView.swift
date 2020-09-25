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
    var models: [String] = {
        let fileManager = FileManager.default
        guard let path = Bundle.main.resourcePath,
              let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        var availableModels = [String]()
        for filename in files where filename.hasSuffix("usdz") {
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            availableModels.append(modelName)
        }
        
        return availableModels
    }()
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer()
//            ModelPickerView(models: models)
            
            PlacementButtonView()
            
        }
        
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
