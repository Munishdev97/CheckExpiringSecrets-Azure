#!/bin/bash

# Set your Azure AD tenant ID
TENANT_ID="a78ecd89-2a60-45a6-890c-803ffeae2338"

# Set the number of days before expiration to notify
DAYS_BEFORE_EXPIRY=7

# Get the list of service principals and their secrets
SERVICE_PRINCIPALS=$(az ad sp list --query "[].{objectId: objectId, displayName: displayName}" --output json)

# Iterate through each service principal
for SP in $(echo "${SERVICE_PRINCIPALS}" | jq -c '.[]'); do
    OBJECT_ID=$(echo "${SP}" | jq -r '.objectId')
    DISPLAY_NAME=$(echo "${SP}" | jq -r '.displayName')

    # Get the list of secrets for the current service principal
    SECRETS=$(az ad sp credential list --id "${OBJECT_ID}" --query "[].{startDate: startDate, endDate: endDate}" --output json)

    # Iterate through each secret
    for SECRET in $(echo "${SECRETS}" | jq -c '.[]'); do
        START_DATE=$(echo "${SECRET}" | jq -r '.startDate')
        END_DATE=$(echo "${SECRET}" | jq -r '.endDate')

        # Calculate the number of days until the secret expires
        EXPIRATION_DATE=$(date -d "${END_DATE}" +%s)
        CURRENT_DATE=$(date +%s)
        DAYS_TO_EXPIRY=$(( (EXPIRATION_DATE - CURRENT_DATE) / 86400 ))

        # Check if the secret is about to expire
        if [ "${DAYS_TO_EXPIRY}" -le "${DAYS_BEFORE_EXPIRY}" ]; then
            # Notify the user about the expiring secret
            echo "Service principal '${DISPLAY_NAME}' (Object ID: ${OBJECT_ID}) has a secret expiring in ${DAYS_TO_EXPIRY} days."
            # You can customize the notification method (email, messaging, etc.) based on your needs.
            # For example, you can send an email to the user responsible for the service principal.
            # mail -s "Service Principal Secret Expiry Notification" user@example.com <<< "Service principal '${DISPLAY_NAME}' has a secret expiring in ${DAYS_TO_EXPIRY} days."
        fi
    done
done