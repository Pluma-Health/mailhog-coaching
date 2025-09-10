# mailhog-coaching
Mailhog is an e-mail testing tool for developers.


## Local Dev setup

Install the packages :

```
npm install
```
Or use the Makefile:

```
make install
```


Generate the .env file using the [PercipioSecretLoader](https://skillsoftdev.atlassian.net/wiki/spaces/PSS/pages/3535470673/Percipio+Secret+Loader) :

```
npm run load-secrets
```

Note : This assume that you are AWS SSOed and that you are using zscaler/cisco connected. You should have this entry in `~/.aws/config`

```
[profile psl]
sso_start_url = https://skillsoftsso.awsapps.com/start
sso_region = us-east-1 sso_account_id = 214559464274
sso_role_name = EngineeringTeamAccess
region = us-east-1 output = json
```

## Start the services

```
npm run start
```

## lint

`npm run lint`

## Start the tests :

### Run the unit tests :

```
npm run test
```

Note : The tests will be run by the pipeline.



## Using the Makefile

This project includes a Makefile to automate common development tasks:

### Available commands

- `make install` - Install dependencies
- `make build` - Build the Docker image for the service
- `make helm-template-all` - Generate Kubernetes manifests for all deployment profiles

### Benefits for local development

The Makefile simplifies development by:

1. Providing consistent commands that work across different environments
2. Automating multi-step processes (like generating Kubernetes manifests for all profiles)
3. Reducing the need to remember complex commands
4. Standardizing build and deployment processes

To use the Makefile, simply run the desired command from the project root directory:

```
make <command>
```