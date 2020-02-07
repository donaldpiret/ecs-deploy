# ecs-deploy
ECS deployment github action based on fabfuel/ecs-deploy

This action deploys ECS services using [fabfuel/ecs-deploy](https://github.com/fabfuel/ecs-deploy) package.

## Usage

### Deployment

#### Simple Redeploy

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
```

### Deploy a new tag

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  tag: 1.2.3
 ```

### Deploy a new image

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  image: webserver nginx:1.11.8
 ```

### Deploy several new images

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  image: webserver nginx:1.11.8, application my-app:1.2.3
 ```

### Deploy a custom task definition

TODO

### Set an environment variable

TODO

### Adjust multiple environment variables

TODO

### Set environment variables exclusively, remove all other pre-existing environment variables

TODO

### Set a secret environment variable from the AWS Parameter Store

TODO

### Set secrets exclusively, remove all other pre-existing secret environment variables

TODO

### Modify a command

TODO

### Set a task role

TODO

### Ignore capacity issues

TODO

### Deployment timeout

TODO

## Scaling

### Scale a service

TODO



