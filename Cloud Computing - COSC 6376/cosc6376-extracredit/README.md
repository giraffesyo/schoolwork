# Write up

The goal is to create a minion summoning REST API backed by Google Spanner, Cloud Functions, and API Gateway.

## Setup

I used the Google Console to deploy the Cloud Spanner instance. The SQL used for the table is:

```sql
CREATE TABLE Minion (
  MinionId STRING(36) NOT NULL,
  Name STRING(100),
  Email STRING(100),
) PRIMARY KEY (MinionId);
```

The Cloud Function is written in JavaScript and uses the `@google-cloud/spanner` library to connect to the Spanner instance. The function is deployed using the `gcloud` CLI. See the [deploy.sh](deploy.sh) script for details.

The config for the API is defined in [openapi.yaml](openapi.yaml). The API is deployed using the `gcloud` CLI. See the [deploy-config.sh](deploy-config.sh) script for details.

The API gateway is deployed using the `gcloud` CLI. See the [deploy-gateway.sh](deploy-gateway.sh) script for details.

## Usage

There are three endpoints:

- `GET /` - Returns a list of minions
- `POST /summon` - Returns the first available minion (deletes that minion from the database so it can't be summoned again)
- `POST /reset` - Resets the database to the original state

## Testing

The API can be tested using the below commands:

### GET /

```bash
curl -X GET https://minions-gateway-93yac1o.ue.gateway.dev
```

This endpoint returns a list of minions. The response will be in the following shape:

```json
[
  {
    "minion_id": "string",
    "minion_name": "string",
    "minion_email": "string"
  }
]
```

### POST /summon

```bash
curl -X POST https://minions-gateway-93yac1o.ue.gateway.dev/summon
```

It's expected the first time you try to summon a minion, you'll get the following error response:

```json
{
  "error": "No minions available"
}
```

This is because the database is empty. You can add minions to the database by using the `POST /reset` endpoint.

After you've added minions to the database, you can summon a minion by using the `POST /summon` endpoint. The response will be in the following shape:

```json
{
  "minion_id": "string",
  "minion_name": "string",
  "minion_email": "string"
}
```

### POST /reset

```bash
curl -X POST https://minions-gateway-93yac1o.ue.gateway.dev/reset
```

This endpoint resets the database to the original state. It's expected that every time time you run this command, you'll get the following response:

```json
{
  {"error":false,"message":"Minions reset"}
}
```
