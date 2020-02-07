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
  if [ -z "$INPUT_TAG" ]
  then
    CMD+=" -t ${INPUT_TAG}"
  elif [ -z "$INPUT_IMAGE" ]; then
    rest=$INPUT_IMAGE
    while [ -n "$rest" ] ; do
      str=${rest%%,*}  # Everything up to the first ','
      # Trim up to the first ',' -- and handle final case, too.
      [ "$rest" = "${rest/,/}" ] && rest= || rest=${rest#*,}

      CMD+="-i $str"
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