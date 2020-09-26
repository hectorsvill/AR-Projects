//
//  Model.swift
//  ModelPickerApp
//
//  Created by Hector Villasano on 9/26/20.
//

import Combine
import RealityKit
import UIKit

class Model  {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)!
        let fileName = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { loadCompletion in
                print("DEBUG: Unable to load ModelEntity for modelName: \(modelName)")
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                print("Success")
            })
        
    }
}
