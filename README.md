# on-premise-deploy
Code and artefacts required to deploy PM4ML in an on-premise environment

## Running payment manager with testing toolkit included

![Payment manager with TTK](/assets/images/ttk-scenario1.png)

### What is Testing Toolkit?

Testing toolkit (TTK) is a tool for simulating and validating mojaloop implementations. We are using TTK in this scenario to simulate a mojaloop switch combined with payee fsp.

### Prerequisites

You need to have the following softwares on your machine
* git
* docker
* docker-compose

Please run the following commands to start the payment manager on your machine
```
git clone https://github.com/pm4ml/on-premise-deploy.git
cd on-premise-deploy/docker-compose
docker-compose up
```

Now a payment manager should be running on your machine with TTK.

### TTK UI

Open the URL http://localhost:6060 for TTK UI
Go to `Monitoring` page.

### Portal UI

You can see all the transfers executed in the payment manager portal.

Open the URL http://localhost:8081 for payment manager UI
Login with the username `test` and password `test`

### Keycloak UI

You can manage the users using the keycloak admin interface on http://localhost:8080
Login with username `admin` and password `admin`

---

## Sending transfer from core connector simulator acting as payer

### Initiate a transfer from command line

Execute the following curl command to send a http request to the simulator core connector for initiating a transfer

```
curl 'http://localhost:3003/sendmoney' -H 'content-type: application/json;charset=utf-8' --data-binary '{"from":{"displayName":"PayerFirst PayerLast","idType":"MSISDN","idValue":"22507008181"},"to":{"idType":"MSISDN","idValue":"22556999125"},"amountType":"SEND","currency":"USD","amount":"100","transactionType":"TRANSFER","note":"test payment","homeTransactionId":"12277380-9d94-4a8a-b49e-0fac3b8b3565"}'
```

Please observe the transfer state 'COMMITTED' indicating a successful transfer.

### Observe the http requests and callbacks in TTK

In the `Monitoring` page opened before, you can see the logs.

### Initiate a transfer from TTK

* Open the menu item `Test Runner` in TTK UI in a new tab.
* Click on `Collection Manager` button and import the file 'testing-toolkit/collections/payer-tests/sendmoney.json'
* Click on `Send` button
* You should see the test run successful
* Click on the edit button against the test case and observe the request sent and response received

You should see the logs about the transaction in the Monitoring page already opened in another tab.

---

## Sending transfer to core connector simulator acting as payee

* Open the menu item `Test Runner` in TTK UI.
* Click on `Collection Manager` button and import the folder 'testing-toolkit/collections/payee-tests'
* In `Collection Manager`, select the file `provision_mojaloop_simulator.json` and close the collection manager
* Click on `Send` button
* Now we added the MSISDN party to the payee simulator
* In `Collection Manager`, select the file `p2p_happy_path.json` and close the collection manager
* Click on `Send` button and see the result
* Click on the edit button against the test case and observe the request sent and response received
