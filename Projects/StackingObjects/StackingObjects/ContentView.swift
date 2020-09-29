//
//  ContentView.swift
//  StackingObjects
//
//  Created by Hector Villasano on 9/29/20.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        arView.enableTapGesture()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView {
    
    func enableTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self)
        
        guard let rayResult = ray(through: tapLocation) else { return }
        
        let results = scene.raycast(origin: rayResult.origin, direction: rayResult.direction)
        
        if let firstResult = results.first {
            //Raycast intersected with AR Object
            // Place object on top of existing AR Object
            
            var position = firstResult.position
            position.y += 0.3/2
            
            placeCube(at: position)
        } else {
            // Raycast has not intersected with AR object
            // Place a new object on a real-world surface (if present)
            
            let results = raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
            
            if let firstResult = results.first {
                let position = simd_make_float3(firstResult.worldTransform.columns.3) // SIMD3<FLOAT> - x,y,z, vector
                placeCube(at: position)
                
            }
        }
    }

    func placeCube(at position: SIMD3<Float>) {
        let mesh = MeshResource.generateBox(size: 0.3)
        let material = SimpleMaterial(color: .white, roughness: 0.3, isMetallic: true)
        
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        modelEntity.generateCollisionShapes(recursive: true)
        
        let anchorentity = AnchorEntity(world: position)
        anchorentity.addChild(modelEntity)
        scene.addAnchor(anchorentity)
        
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
