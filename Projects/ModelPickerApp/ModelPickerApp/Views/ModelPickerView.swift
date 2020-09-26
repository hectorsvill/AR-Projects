//
//  ModelPickerView.swift
//  ModelPickerApp
//
//  Created by Hector Villasano on 9/25/20.
//

import SwiftUI

struct ModelPickerView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    
    var models: [Model]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0 ..< self.models.count) { index in
                    let model = self.models[index]
                    
                    Button(action: {
                        self.selectedModel = model
                        isPlacementEnabled = true
                    }) {
                        if let image = model.image {
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

