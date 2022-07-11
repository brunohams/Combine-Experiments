//
// Created by PremierSoft on 11/07/22.
//

import Foundation

class PTTController {

    let viewModel: PTTViewModel
    let transmissionReducer: TransmissionReducer

    init(viewModel: PTTViewModel, transmissionReducer: TransmissionReducer) {
        self.viewModel = viewModel
        self.transmissionReducer = transmissionReducer
    }

    func togglePTT() {
        transmissionReducer.on(subject: viewModel.pttSubject)
    }

}