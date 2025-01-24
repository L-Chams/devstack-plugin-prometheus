# check for service enabled
if is_service_enabled prometheus; then
    if [[ "$1" == "source" ]]; then
        # Initial source of lib script
        source $(dirname "$0")/lib/prometheus
    fi

    if [[ "$1" == "stack" && "$2" == "pre-install" ]]; then
        # Set up system services
        echo_summary "Configuring system services prometheus"
        pre_install_prometheus

    elif [[ "$1" == "stack" && "$2" == "install" ]]; then
        # Perform installation of service source
        echo_summary "Installing prometheus"
        install_prometheus

    elif [[ "$1" == "stack" && "$2" == "post-config" ]]; then
        # Configure after the other layer 1 and 2 services have been configured
        echo_summary "Configuring prometheus"
        configure_prometheus

    elif [[ "$1" == "stack" && "$2" == "extra" ]]; then
        # Initialize and start the prometheus service
        echo_summary "Initializing prometheus"
        init_prometheus
    fi

    if [[ "$1" == "unstack" ]]; then
        # Shut down prometheus services
        # no-op
        shutdown_prometheus
    fi

    if [[ "$1" == "clean" ]]; then
        # Remove state and transient data
        # Remember clean.sh first calls unstack.sh
        # no-op
        cleanup_prometheus
    fi
fi
