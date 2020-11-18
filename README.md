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

#### Deploy a new tag

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  tag: 1.2.3
 ```

#### Deploy a new image

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  image: webserver nginx:1.11.8
 ```

#### Deploy several new images

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  image: webserver nginx:1.11.8, application my-app:1.2.3
 ```

#### Deploy a custom task definition

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

#### Set an environment variable

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  env_vars: containerName SOME_VARIABLE SOME_VALUE
 ```

#### Adjust multiple environment variables

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  env_vars: containerName SOME_VARIABLE SOME_VALUE, containerName OTHER_VARIABLE OTHER_VALUE, appContainerName APP_VARIABLE APP_VALUE
 ```

#### Set environment variables exclusively, remove all other pre-existing environment variables

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  env_vars: containerName SOME_VARIABLE SOME_VALUE
  exclusive_env: true
 ```

#### Set a secret environment variable from the AWS Parameter Store or Secrets Manager

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  secrets: containerName SOME_SECRET arn:aws:ssm:<aws region>:<aws account id>:parameter/KEY_OF_SECRET_IN_PARAMETER_STORE
 ```

#### Set secrets exclusively, remove all other pre-existing secret environment variables

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  secrets: containerName SOME_SECRET arn:aws:ssm:<aws region>:<aws account id>:parameter/KEY_OF_SECRET_IN_PARAMETER_STORE
  exclusive_secrets: true 
```

#### Modify a command

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  command: containerName "nginx -c /etc/nginx/nginx.conf"
```

#### Set a task role

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  task_role: arn:aws:iam::123456789012:role/MySpecialEcsTaskRole
```

#### Ignore capacity issues

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  ignore_warnings: true
```

#### Disable task definition deregistration

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  no_deregister: true
```

#### Rollback on failure

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  rollback: true
```

#### Deployment timeout

```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  timeout: 1200
```

To run a deployment without waiting for the successful or failed result at all, set timeout to the value of -1.


```yml
uses: donaldpiret/ecs-deploy@master
with:
  cluster: theClusterName
  target: theServiceName
  timeout: -1
```

### Deploy a Scheduled Task (Cron) Update

The `cron` action deploys a new task definition to a Scheduled Task rule. The `target` should be a task definition
family name, and the `rule` option must specify the CloudWatch Events rule name.

```yml
uses: donaldpiret/ecs-deploy@master
with:
  action: cron
  cluster: theClusterName
  target: taskName
  rule: ruleName
  image: application my-app:1.2.3
```

The following options work the same with `cron` as with `deploy` to update the task definition:

- `image`
- `tag`
- `env_vars`
- `exclusive_env`
- `task_role`
- `command`
- `no_deregister`
- `rollback`

### Scaling

#### Scale a service

```yml
uses: donaldpiret/ecs-deploy@master
with:
  action: scale
  cluster: theClusterName
  target: theServiceName
  scale_value: 4
```

### Running a Task

#### Run a one-off task

```yml
uses: donaldpiret/ecs-deploy@master
with:
  action: run
  cluster: theClusterName
  target: taskName:taskRevision
```

You can define environment variables just like for deploy

```yml
uses: donaldpiret/ecs-deploy@master
with:
  action: run
  cluster: theClusterName
  target: taskName:taskRevision
  env_vars: containerName SOME_VARIABLE SOME_VALUE, containerName OTHER_VARIABLE OTHER_VALUE, appContainerName APP_VARIABLE APP_VALUE
 ```

#### Run a task with a custom command

```yml
uses: donaldpiret/ecs-deploy@master
with:
  action: run
  cluster: theClusterName
  target: taskName:taskRevision
  command: my-container "python some-script.py param1 param2"
```

#### Run a task in a Fargate Cluster

TODO

