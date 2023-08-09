//
//  SpeechController.swift
//  speech2operate
//
//  Created by rei.nakaoka on 2023/08/09.
//

import Combine
import Speech
import SwiftAutoGUI
import AVFoundation

class SpeechController: ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    private var lastTranscription: SFTranscription?
    @Published var commandText = ""

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
                let newTranscription = result.bestTranscription
                let newText = self.getNewlyRecognizedText(from: newTranscription)
                self.commandText += newText
                print(self.commandText)

                self.processCommand(self.commandText)
                self.lastTranscription = newTranscription
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

    private func getNewlyRecognizedText(from newTranscription: SFTranscription) -> String {
        guard let oldTranscription = lastTranscription else {
            return newTranscription.formattedString
        }

        let oldText = oldTranscription.formattedString
        let newText = newTranscription.formattedString

        if let range = newText.range(of: oldText) {
            let newPart = newText.replacingCharacters(in: range, with: "")
            return newPart.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return ""
        }
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }

    func resetCommand() {
        commandText = ""
    }

    private func processCommand(_ command: String) {
        guard let command = Command(command) else { return }
        command.process()
        resetCommand()
    }

}
