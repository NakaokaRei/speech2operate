//
//  ContentView.swift
//  speech2operate
//
//  Created by rei.nakaoka on 2023/08/08.
//

import SwiftUI

struct ContentView: View {

    @StateObject var speechController = SpeechController()

    var body: some View {
        VStack {
            Text(speechController.commandText)
                .font(.title)
                .padding()
            Button("Start Recording") {
                try? speechController.startRecording()
            }
            Button("Reset") {
                speechController.stopRecording()
                speechController.resetCommand()
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
