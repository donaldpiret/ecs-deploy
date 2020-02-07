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

With a fully-qualified ARN

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  task: arn:aws:ecs:eu-central-1:123456789012:task-definition/my-task:20
 ```

With a task family name with revision

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  task: my-task:20
 ```

Or just a task family name. It this case, the most recent revision is used

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  task: my-task
 ```

### Set an environment variable

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  env_vars: SOME_VARIABLE SOME_VALUE
 ```

### Adjust multiple environment variables

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  env_vars: SOME_VARIABLE SOME_VALUE, OTHER_VARIABLE OTHER_VALUE, APP_VARIABLE APP_VALUE
 ```

### Set environment variables exclusively, remove all other pre-existing environment variables

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  env_vars: SOME_VARIABLE SOME_VALUE
  exclusive_env: true
 ```

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



