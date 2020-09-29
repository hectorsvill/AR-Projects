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

let size: Float = 0.1
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
            
            position.y += size/2
            
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
        let mesh = MeshResource.generateBox(size: size)
        let material = SimpleMaterial(color: .randomColor(), roughness: MaterialScalarParameter(floatLiteral: size), isMetallic: true)
        
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        modelEntity.generateCollisionShapes(recursive: true)
        
        let anchorentity = AnchorEntity(world: position)
        anchorentity.addChild(modelEntity)
        scene.addAnchor(anchorentity)
        
    }
}

extension UIColor {
    class func randomColor() -> UIColor {
        let colors: [UIColor] = [.red, .green, .blue, purple, .yellow]
        let randomIndex = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randomIndex]
//        return colors.randomElement()!
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
