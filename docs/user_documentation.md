# Bastion user documentation example

## Commands to use

### Connect to the bastion

The bastion is the entrypoint to the services deployed on GCP.
```bash
gcloud auth login
gcloud compute ssh <BASTION_NAME> --project=<PROJECT_NAME> --zone=<REGION>
```

### Connect to the CloudSQL instance

In a first terminal, run the following commands to create a SSH tunnel that forwards traffic from port `5432` of your local machine to port `5432` on the internal IP of your database (in our example `10.1.2.3`) within the VPC network, using Identity-Aware Proxy (IAP).
Note that the IP may be different for each database.
You will find it on the SQL Intances page in the GCP Console.

```bash
gcloud auth login
gcloud compute ssh non-production-bastion --zone=<REGION> --tunnel-through-iap --ssh-flag "-L 5432:10.1.2.3:5432 -N" --project=<PROJECT_NAME>
```

Once the tunnel is set up, open a second terminal.
Run the following command to get the password of the PostgreSQL database :

```bash
gcloud secrets versions access latest --secret=<SECRET_NAME> --project="<PROJECT-ID>"
```

You will get the password in clear in your terminal. The password ends before the last: `%`.
Then, run the following command to connect to the database.
When prompted to give a password, use the output of the previous command.

```bash
psql -h 127.0.0.1 -p 5432 -U user
```

### Connect to the MemoryStore instance

In a first terminal, run the following commands to create a SSH tunnel that forwards traffic from port `6378` of your local machine to port `6378` on the internal IP of your redis instance (in our example `10.4.5.6`) within the VPC network, using Identity-Aware Proxy (IAP).
Note that the IP will be different for each redis instance.
You will find it on the Memorystore Intances page in the GCP Console.

```bash
gcloud auth login
gcloud compute ssh non-production-bastion --zone=<REGION> --tunnel-through-iap --ssh-flag "-L 6378:10.4.5.6:6378 -N" --project=<PROJECT_NAME>
```

Open a second terminal and run the following command :

```bash
redis-cli -h 127.0.0.1 -p 6378 -U user
```
