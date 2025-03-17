# check for service enabled

# Save trace setting
_XTRACE_PROMETHEUS_PLUGIN=$(set +o | grep xtrace)
set -o xtrace

echo_summary "devstack-plugin-prometheus's plugin.sh was called..."
. $DEST/devstack-plugin-prometheus/devstack/lib/prometheus
. $DEST/devstack-plugin-prometheus/devstack/lib/node_exporter

# Show all of defined environment variables
(set -o posix; set)

## Prometheus
if is_service_enabled prometheus; then
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

    elif [[ "$1" == "stack" && "$2" == "test-config" ]]; then
        # Initialize and start the prometheus service
        echo_summary "Initializing prometheus"
        init_prometheus
        echo_summary "Starting prometheus service"
        start_prometheus
        echo_summary "Give time to prometheus to scrape data"
        wait_for_data
        check_data_prometheus
    fi

    if [[ "$1" == "unstack" ]]; then
        # Shut down prometheus services
        # no-op
        echo_summary "Stoping prometheus service"
        stop_prometheus
        echo_summary "Cleaning prometheus service"
        cleanup_prometheus
    fi

    if [[ "$1" == "clean" ]]; then
        # Remove state and transient data
        # Remember clean.sh first calls unstack.sh
        # no-op
        echo_summary "Cleaning prometheus service"
        cleanup_prometheus
    fi
fi

## Node Exporter
if is_service_enabled node_exporter; then
    if [[ "$1" == "source" ]]; then
        # Initial source of lib script
        source $(dirname "$0")/lib/node_exporter
    fi

    if [[ "$1" == "stack" && "$2" == "pre-install" ]]; then
        # Set up system services
        echo_summary "Configuring system services node exporter"
        pre_install_node_exporter

    elif [[ "$1" == "stack" && "$2" == "install" ]]; then
        # Perform installation of service source
        echo_summary "Installing node exporter"
        install_node_exporter

    elif [[ "$1" == "stack" && "$2" == "post-config" ]]; then
        # Configure after the other layer 1 and 2 services have been configured
        echo_summary "Configuring node_exporter"
        init_node_exporter
        echo_summary "Starting node exporter service"
        start_node_exporter
        echo_summary "Give time to node_exporter to push metrics"
        wait_for_data
        check_data_node_exporter
    fi

    if [[ "$1" == "unstack" ]]; then
        # Shut down node exporter services
        # no-op
        echo_summary "Stoping node_exporter service"
        stop_node_exporter
        echo_summary "Cleaning node exporter service"
        cleanup_node_exporter
    fi

    if [[ "$1" == "clean" ]]; then
        # Remove state and transient data
        # Remember clean.sh first calls unstack.sh
        # no-op
        echo_summary "Cleaning node exporter service"
        cleanup_node_exporter
    fi
fi
