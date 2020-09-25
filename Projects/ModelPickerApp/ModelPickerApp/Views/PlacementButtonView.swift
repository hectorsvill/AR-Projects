//
//  PlacementButtonView.swift
//  ModelPickerApp
//
//  Created by Hector Villasano on 9/25/20.
//

import SwiftUI

struct PlacementButtonView: View {
    var body: some View {
        HStack {
            Button(action: {
                print("Cancel")
            }){
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }

            Button(action: {
                print("Confirmed")
            }){
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
}
