#!/bin/sh -l

set -e o pipefail

# Validate input
[ -z "$INPUT_ACTION" ] && (echo "Missing action" && exit 1)
[ -z "$INPUT_CLUSTER" ] && (echo "Missing Cluster Name" && exit 1)
[ -z "$INPUT_TARGET" ] && (echo "Missing target" && exit 1)

# TIMEOUT=${INPUT_TIMEOUT:-300}

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

  if [ -n "$INPUT_ENV_VARS" ]; then # Env vars
    rest=$INPUT_ENV_VARS
    while [ -n "$rest" ] ; do
      str=${rest%%,*}  # Everything up to the first ','
      # Trim up to the first ',' -- and handle final case, too.
      [ "$rest" = "${rest/,/}" ] && rest= || rest=${rest#*,}

      CMD="${CMD} -e $str"
    done
  fi
}

case $INPUT_ACTION in
deploy) # Deployment action
  echo "Performing deploy"
  deploy_action
  ;;
esac

eval "$CMD"