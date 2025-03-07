#!/bin/bash
set -euo pipefail

#
# Check if latest chart version matches the latest release.
#

helm repo add camunda https://helm.camunda.io
helm repo update
chart_main_version="$(yq '.version' charts/camunda-platform/Chart.yaml)"
components_versions="$(helm template camunda/camunda-platform | grep -Po '(?<=helm.sh/chart: ).+' | sort | uniq)"
components_count=7

print_components_versions() {
    echo "Current versions from Camunda Helm repo:"
    printf -- "- %s\n" ${components_versions}
}

if [[ $(echo "${components_versions}" | grep -c "${chart_main_version}") -lt "${components_count}" ]]; then
    echo '[ERROR] Not all Camunda Platform components are updated!'
    print_components_versions
    exit 1
fi

echo '[INFO] All Camunda Platform components are updated.'
print_components_versions
exit 0
