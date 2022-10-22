//
//  ViewController.swift
//  customCreditCardKeyboard
//
//  Created by Burak Colak on 21.10.2022.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var tfCreditCard: UITextField!

    private var delegate: CreditCardDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = CreditCardDelegate(tfCreditCard)
        tfCreditCard.text = delegate?.getDefaultMask()
        tfCreditCard.delegate = delegate
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate = nil
    }

    @IBAction func onDoneTapped(_ sender: Any) {
        print(delegate?.getFirstPart() ?? "")
        print(delegate?.getSecondPart() ?? "")
    }
}
