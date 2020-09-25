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
    var models = ["stratocaster", "teapot", "biplane", "vintagerobot2k"]
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer()
            ModelPickerView(models: models)
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

struct ModelPickerView: View {
    var models: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0 ..< self.models.count) { index in
                    let model = self.models[index]
                    
                    Button(action: {
                        print(model)
                        
                    }) {
                        if let image = UIImage(named: model) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(height: 80)
                                .aspectRatio(1/1,contentMode: .fit)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}



#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
