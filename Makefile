.PHONY: help build k3d-import

IMAGE_NAME := pflex-module-rs
ECR_REGISTRY := 401732561735.dkr.ecr.eu-west-1.amazonaws.com
K3D_CLUSTER := pflex-cluster

help: ## Display this help message.
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; \
	{cmd=sprintf("\033[1;34m%-18s\033[0m", $$1); printf "  %s - %s\n", cmd, $$2}'

build: ## Build the Docker image locally.
	./docker/build.sh

k3d-import: ## Build and import the Docker image into k3d.
	IMAGE_TAG=local ./docker/build.sh --ecr
	k3d image import -c $(K3D_CLUSTER) $(ECR_REGISTRY)/$(IMAGE_NAME):local

.DEFAULT_GOAL := help
