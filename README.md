Custom credit card mask delegate sample app.

How to use ?

1. Copy CreditCardDelegate into your project
2. In the viewDidLoad;
delegate = CreditCardDelegate(tfCreditCard)
tfCreditCard.text = delegate?.getDefaultMask()
tfCreditCard.delegate = delegate

In the viewDidDisappear;
delegate = nil