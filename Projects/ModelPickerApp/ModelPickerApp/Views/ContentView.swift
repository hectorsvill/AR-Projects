//
//  ContentView.swift
//  ModelPickerApp
//
//  Created by Hector Villasano on 9/25/20.
//

import ARKit
import SwiftUI
import RealityKit
import FocusEntity

struct ContentView : View {
    @State private var isPlacementEnabled = false
    @State private var selectedModel: Model?
    @State private var modelConfirmedForPlacement: Model?
    
    var models: [Model] = {
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.resourcePath,
              let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        var availableModels = [Model]()
        
        for filename in files where filename.hasSuffix("usdz") {
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            
            let model = Model(modelName: modelName)
            availableModels.append(model)
        }
        
        return availableModels
    }()
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(modelConfirmedForPlacement: $modelConfirmedForPlacement)
            
            if self.isPlacementEnabled {
                PlacementButtonView(isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, modelConfirmedForPlacement: $modelConfirmedForPlacement)
            } else {
                ModelPickerView(isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, models: models)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        FocusARView(frame: .zero)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = modelConfirmedForPlacement,
           let modelEntity = model.modelEntity {
            
            let anchorEnitity = AnchorEntity(plane: .any)
            anchorEnitity.addChild(modelEntity.clone(recursive: true))
            uiView.scene.addAnchor(anchorEnitity)
        } else {
            print("DEBUG: Unable to load model entity")
        }
        
        DispatchQueue.main.async {
            self.modelConfirmedForPlacement = nil
        }
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
