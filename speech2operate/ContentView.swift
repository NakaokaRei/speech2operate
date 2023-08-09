//
//  ContentView.swift
//  speech2operate
//
//  Created by rei.nakaoka on 2023/08/08.
//

import SwiftUI

struct ContentView: View {

    let speechController = SpeechController()

    var body: some View {
        VStack {
            Button("Start Recording") {
                try? speechController.startRecording()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
