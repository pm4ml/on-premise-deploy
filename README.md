# on-premise-deploy
Code and artefacts required to deploy PM4ML in an on-premise environment

## Running the payment manager

```
git clone https://github.com/pm4ml/on-premise-deploy.git
cd on-premise-deploy/docker-compose
docker-compose up
```

## Configuration

You need to change the configuration parameter 'PEER_ENDPOINT' of the service 'mojaloop-connector' to execute a transfer.

## Initiate a transfer

Send the following http request to the simulator core connector to initiate a transfer

```
curl 'http://localhost:3003/sendmoney' -H 'content-type: application/json;charset=utf-8' --data-binary '{"from":{"displayName":"PayerFirst PayerLast","idType":"MSISDN","idValue":"22507008181"},"to":{"idType":"MSISDN","idValue":"22556999125"},"amountType":"SEND","currency":"USD","amount":"100","transactionType":"TRANSFER","note":"test payment","homeTransactionId":"12277380-9d94-4a8a-b49e-0fac3b8b3565"}'
```

## Portal UI

Open the URL http://localhost:8081 for payment manager UI
Login with the username `test` and password `test`

## Keycloak UI

You can manage the users using the keycloak admin interface on http://localhost:8080
Login with username `admin` and password `admin`
