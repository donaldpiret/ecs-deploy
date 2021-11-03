#!/bin/sh -l

set -e o pipefail

# Validate input
[ -z "$INPUT_ACTION" ] && (echo "Missing action" && exit 1)
[ -z "$INPUT_CLUSTER" ] && (echo "Missing Cluster Name" && exit 1)
[ -z "$INPUT_TARGET" ] && (echo "Missing target" && exit 1)

TIMEOUT=${INPUT_TIMEOUT:-300}

CMD="ecs ${INPUT_ACTION} ${INPUT_CLUSTER} ${INPUT_TARGET}"

## Deploy function
deploy_action() {
  if [ -n "$INPUT_TAG" ]; then # Deploying a specific tag
    CMD="${CMD} -t ${INPUT_TAG}"
  elif [ -n "$INPUT_IMAGE" ]; then # Deploying one or more images
    rest=$INPUT_IMAGE
    while [ -n "$rest" ] ; do
      str=${rest%%,*}  # Everything up to the first ','
      # Trim up to the first ',' -- and handle final case, too.
      [ "$rest" = "${rest/,/}" ] && rest= || rest=${rest#*,}

      CMD="${CMD} -i $str"
    done
  elif [ -n "$INPUT_TASK" ]; then # Deploying a specific task definition
    CMD="${CMD} --task ${INPUT_TASK}"
  fi
}

## Cron function
cron_action() {
  [ -z "$INPUT_RULE" ] && (echo "Missing rule" && exit 1)

  CMD="${CMD} ${INPUT_RULE}"

  if [ -n "$INPUT_TAG" ]; then # Deploying a specific tag
    CMD="${CMD} -t ${INPUT_TAG}"
  elif [ -n "$INPUT_IMAGE" ]; then # Deploying one or more images
    rest=$INPUT_IMAGE
    while [ -n "$rest" ] ; do
      str=${rest%%,*}  # Everything up to the first ','
      # Trim up to the first ',' -- and handle final case, too.
      [ "$rest" = "${rest/,/}" ] && rest= || rest=${rest#*,}

      CMD="${CMD} -i $str"
    done
  fi
}

## Scale function
scale_action() {
  [ -z "$INPUT_SCALE_VALUE" ] && (echo "Missing scale value" && exit 1)
  CMD="${CMD} ${INPUT_SCALE_VALUE}"
}

## Run function
run_action() {
  CMD="${CMD}"
}

## Update function
update_action() {
  CMD="ecs update ${INPUT_TARGET}"
}

append_common_vars() {
  if [ -n "$INPUT_ENV_VARS" ]; then # Env vars
    rest=$INPUT_ENV_VARS
    while [ -n "$rest" ] ; do
      str=${rest%%,*}  # Everything up to the first ','
      # Trim up to the first ',' -- and handle final case, too.
      [ "$rest" = "${rest/,/}" ] && rest= || rest=${rest#*,}

      CMD="${CMD} -e $str"
    done
  fi

  if [ "$INPUT_EXCLUSIVE_ENV" = "true" ]; then
    CMD="${CMD} --exclusive-env"
  fi

  if [ -n "$INPUT_SECRETS" ]; then # Secrets
    rest=$INPUT_SECRETS
    while [ -n "$rest" ] ; do
      str=${rest%%,*}  # Everything up to the first ','
      # Trim up to the first ',' -- and handle final case, too.
      [ "$rest" = "${rest/,/}" ] && rest= || rest=${rest#*,}

      CMD="${CMD} -s $str"
    done
  fi

  if [ "$INPUT_EXCLUSIVE_SECRETS" = "true" ]; then
    CMD="${CMD} --exclusive-secrets"
  fi

  if [ -n "$INPUT_COMMAND" ]; then # Custom command
    CMD="${CMD} --command \"${INPUT_COMMAND}\""
  fi
}

append_deploy_vars() {
  if [ -n "$INPUT_TASK_ROLE" ]; then # Task role
    CMD="${CMD} -r ${INPUT_TASK_ROLE}"
  fi

  if [ "$INPUT_IGNORE_WARNINGS" = "true" ]; then
    CMD="${CMD} --ignore-warnings"
  fi

  if [ "$INPUT_NO_DEREGISTER" = "true" ]; then
    CMD="${CMD} --no-deregister"
  fi

  if [ "$INPUT_ROLLBACK" = "true" ]; then
    CMD="${CMD} --rollback"
  fi

  if [ "$INPUT_ACTION" != "cron" ]; then
    CMD="${CMD} --timeout ${TIMEOUT}"
  fi
}

append_run_vars() {
  if [ -n "$INPUT_LAUNCH_TYPE" ]; then # Launch Type
    CMD="${CMD} --launchtype=${INPUT_LAUNCH_TYPE}"
  fi

  if [ -n "$INPUT_SECURITY_GROUP" ]; then # Security Group
    CMD="${CMD} --securitygroup ${INPUT_SECURITY_GROUP}"
  fi

  if [ -n "$INPUT_SUBNET" ]; then # Subnet
    CMD="${CMD} --subnet ${INPUT_SUBNET}"
  fi

  if [ "$INPUT_public_ip" = "true" ]; then
    CMD="${CMD} --public-ip"
  fi
}

case $INPUT_ACTION in
deploy) # Deployment action
  echo "Performing deploy"
  deploy_action
  append_common_vars
  append_deploy_vars
  ;;
cron) # Cron action
  echo "Performing cron"
  cron_action
  append_common_vars
  append_deploy_vars
  ;;
scale) # Scaling action
  echo "Performing scaling"
  scale_action
  ;;
run) # Run action
  echo "Performing run"
  run_action
  append_common_vars
  append_run_vars
  ;;
update) # Update action
  echo "Performing update"
  update_action
  append_common_vars
esac

echo "Command run: ${CMD}"

eval "$CMD"
