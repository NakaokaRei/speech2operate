//
//  ContentView.swift
//  speech2operate
//
//  Created by rei.nakaoka on 2023/08/08.
//

import SwiftUI

struct ContentView: View {

    @StateObject var speechController = SpeechController()
    @State var recording = false

    var body: some View {
        VStack(spacing: 20) {
            Text("コマンドを話してください")
                .font(.largeTitle)
                .padding()

            Text(speechController.commandText)
                .font(.title)
                .padding()

            HStack {
                Button(action: {
                    try? speechController.startRecording()
                    recording = true
                }) {
                    if recording {
                        Image(systemName: "mic.circle.fill")
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    } else {
                        Image(systemName: "mic.circle")
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                Button(action: {
                    speechController.stopRecording()
                    speechController.resetCommand()
                    recording = false
                }) {
                    Image(systemName: "stop.fill")
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .frame(width: 500, height: 300)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
