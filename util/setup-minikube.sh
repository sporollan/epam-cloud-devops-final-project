#!/bin/bash

# Variables
PROFILE_NAME="epam-project"  # Name of the Minikube profile
K8S_VERSION="v1.27.4"       # Kubernetes version (optional)
MEMORY="6144"              # Memory allocation for Minikube (in MB)
CPUS="4"                   # Number of CPUs for Minikube
INGRESS=true               # Enable ingress addon
MANIFEST_DIR="k8s/overlays/dev"  # Directory containing your Kustomize manifests

# Function to display usage
usage() {
    echo "Usage: $0 [start|stop|apply]"
    echo "  start   - Start Minikube with the specified profile"
    echo "  stop    - Stop the Minikube profile"
    echo "  apply   - Apply Kubernetes manifests to the active Minikube profile"
    exit 1
}

# Ensure at least one argument is provided
if [[ $# -eq 0 ]]; then
    usage
fi

# Handle commands
case "$1" in
    start)
        echo "Starting Minikube profile '$PROFILE_NAME'..."
        minikube start \
            --profile="$PROFILE_NAME" \
            --kubernetes-version="$K8S_VERSION" \
            --memory="$MEMORY" \
            --cpus="$CPUS" \
            --addons=ingress

        if [[ $? -ne 0 ]]; then
            echo "Failed to start Minikube profile."
            exit 1
        fi

        echo "Minikube profile '$PROFILE_NAME' started successfully."

        # Set kubectl context to the Minikube profile
        echo "Setting kubectl context to Minikube profile '$PROFILE_NAME'..."
        kubectl config use-context "$PROFILE_NAME"

        if [[ $? -ne 0 ]]; then
            echo "Failed to set kubectl context."
            exit 1
        fi

        echo "kubectl context set to Minikube profile '$PROFILE_NAME'."
        ;;

    stop)
        echo "Stopping Minikube profile '$PROFILE_NAME'..."
        minikube stop --profile="$PROFILE_NAME"

        if [[ $? -ne 0 ]]; then
            echo "Failed to stop Minikube profile."
            exit 1
        fi

        echo "Minikube profile '$PROFILE_NAME' stopped successfully."
        ;;

    apply)
        echo "Applying Kubernetes manifests from '$MANIFEST_DIR'..."

        # Check if kubectl is configured to use the correct context
        CURRENT_CONTEXT=$(kubectl config current-context)
        if [[ "$CURRENT_CONTEXT" != "$PROFILE_NAME" ]]; then
            echo "Error: kubectl is not configured to use the Minikube profile '$PROFILE_NAME'."
            echo "Run './setup-minikube.sh start' first."
            exit 1
        fi

        # Apply manifests using kubectl or kustomize
        if [[ -d "$MANIFEST_DIR" ]]; then
            kubectl apply -k "$MANIFEST_DIR"

            if [[ $? -ne 0 ]]; then
                echo "Failed to apply Kubernetes manifests."
                exit 1
            fi

            echo "Kubernetes manifests applied successfully."
        else
            echo "Error: Manifest directory '$MANIFEST_DIR' does not exist."
            exit 1
        fi
        ;;

    *)
        usage
        ;;
esac