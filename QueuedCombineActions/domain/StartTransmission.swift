//
// Created by Bruno on 07/07/22.
//

import Foundation
import Combine

class StartTransmission {

    private let signalingService: SignalingService
    private let rtcService: RTCService
    private let presenter: StartTransmissionPresentable
    private let publisher = PassthroughSubject<String, Never>()

    init(rtcService: RTCService, signalingService: SignalingService,presenter: StartTransmissionPresentable) {
        presenter.subscribe(to: publisher.eraseToAnyPublisher())
        self.presenter = presenter
        self.signalingService = signalingService
        self.rtcService = rtcService
    }

    func execute() async {
        subscribe(to: rtcService.eventPublisher)
        do {
            if (try await signalingService.requestToStartTransmission()) {
                try await rtcService.startTransmission()
            }
        } catch SignalingServiceError.failToRequestStart {
            await freeChannel()
        } catch RTCServiceError.failToStartTransmission {
            await stopTransmissionAndFreeChannel()
        } catch {
            await stopTransmissionAndFreeChannel()
        }
    }

    private func subscribe(to publisher: PassthroughSubject<String, Never>) {
        var cancellable: AnyCancellable?
        cancellable = publisher
            .sink(receiveCompletion: { completion in
                cancellable?.cancel()
            }, receiveValue: { [self] event in
                handleEvent(event)
            })
    }

    private func handleEvent(_ event: String) {
        print("STARTING - handling with event: \(event) - \(getCurrentTime())")
        if event == "Transmissao iniciada" {
            delay(millis: 200)
            publisher.send("Pode Falar")
        }
        if event == "Transmissao finalizada" {
            delay(millis: 200)
            publisher.send("Pode parar de falar")
        }
        print("DONE --- handling with event: \(event)- \(getCurrentTime())")
    }

    private func freeChannel() async {
        try? await signalingService.informEndOfTransmission()
        publisher.send("Deu ruim")
    }

    private func stopTransmissionAndFreeChannel() async {
        try? await rtcService.stopTransmission()
        try? await signalingService.informEndOfTransmission()
        publisher.send("Deu ruim")
    }

}
