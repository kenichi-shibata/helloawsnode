#!/bin/bash

case $1 in 
  build)
	AWS_PROFILE="test.builder" packer build -var-file=variables.json packer.json
        ;;
  validate)
        packer validate -var-file=variables.json packer.json 
	;;

        *)
            echo $"Usage: $0 {build|validate}"
            exit 1
esac
