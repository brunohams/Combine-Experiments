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
        self.presenter = presenter
        self.signalingService = signalingService
        self.rtcService = rtcService
    }

    func execute() async {
        presenter.subscribe(to: publisher.eraseToAnyPublisher())
        do {
            if (try await signalingService.requestToStartTransmission()) {
                try await startTransmission()
            }
        } catch {
            publisher.send("Deu ruim")
        }
    }

    private func startTransmission() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            var cancellable: AnyCancellable?
            cancellable = rtcService
                    .startTransmission()
                    .flatMap { event in
                        Future<String, Never> { [self] promise in
                            Task {
                                try await handleEvent(event)
                                promise(.success(event))
                            }
                        }
                    }
                    .sink { value in
                        if (value == "Erro") {
                            print("Got ERROR - Finalizing job...")
                            continuation.resume(throwing: NSError(domain: "erro", code: 123))
                            cancellable?.cancel()
                        }
                        if value == "Transmissao iniciada" {
                            print("Got SUCCESS - Finalizing job...")
                            continuation.resume()
                            cancellable?.cancel()
                        }
                    }
        }
    }

    private func handleEvent(_ event: String) async throws {
        print("handling with event: \(event)")
        if (event == "Erro") {
            delay(millis: 200)
            publisher.send("Deu ruim")
        }

        if event == "Transmissao iniciada" {
            delay(millis: 200)
            publisher.send("Pode Falar")
        }
        print("DONE --- handling with event: \(event)")
    }

}
