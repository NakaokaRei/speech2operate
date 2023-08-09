//
//  SpeechController.swift
//  speech2operate
//
//  Created by rei.nakaoka on 2023/08/09.
//

import Speech
import SwiftAutoGUI
import AVFoundation

class SpeechController {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    func startRecording() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false

            if let result = result {
                print(result.bestTranscription.formattedString)
                self.processCommand(result.bestTranscription.formattedString)
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    func processCommand(_ command: String) {
        if command.contains("マウスを右に移動") {
            SwiftAutoGUI.moveMouse(dx: 10, dy: 0)
        } else if command.contains("音量を上げる") {
            SwiftAutoGUI.keyDown(.soundUp)
            SwiftAutoGUI.keyUp(.soundUp)
        } else if command.contains("スクロールダウン") {
            SwiftAutoGUI.vscroll(clicks: -10)
        }
    }
}
