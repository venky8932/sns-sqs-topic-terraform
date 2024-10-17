stage('User Confirmation') {
            steps {
                script {
                    // Pop-up asking for user confirmation to proceed or abort
                    def userInput = input(
                        id: 'ProceedOrAbort', message: 'Do you want to proceed with Terraform Apply/Destroy?', parameters: [
                            [$class: 'BooleanParameterDefinition', defaultValue: true, description: 'Proceed with Terraform apply/destroy?', name: 'Proceed']
                        ]
                    )
                    // Check the user's input
                    if (userInput == false) {
                        error "User chose to abort the operation. Pipeline will stop."
                    }
                }
            }
        }




import requests

# Set up your New Relic API key and Monitor ID
API_KEY = 'YOUR_NEW_RELIC_API_KEY'  # Replace with your New Relic API key
MONITOR_ID = 'YOUR_MONITOR_ID'      # Replace with your Synthetic Monitor ID
ACCOUNT_ID = 'YOUR_ACCOUNT_ID'      # Replace with your New Relic Account ID

# New Relic REST API endpoint for Synthetic Monitor metrics
url = f'https://api.newrelic.com/v2/synthetics/monitors/{MONITOR_ID}.json'

# Set up the request headers
headers = {
    'Api-Key': API_KEY,
    'Content-Type': 'application/json'
}

# Make the API request
response = requests.get(url, headers=headers)

# Check if the request was successful
if response.status_code == 200:
    # Parse the JSON response
    monitor_data = response.json()
    print("Monitor Data:")
    print(monitor_data)
else:
    print(f"Failed to fetch monitor data. Status Code: {response.status_code}")
    print("Response:", response.text)

# Fetch ping metrics using New Relic Insights API
# Query Example for Average Ping Response Time (change NRQL as needed)
nrql_query = 'SELECT average(duration) FROM SyntheticCheck WHERE monitorId = \'{monitor_id}\''.format(monitor_id=MONITOR_ID)

insights_url = f'https://insights-api.newrelic.com/v1/accounts/{ACCOUNT_ID}/query'
insights_headers = {
    'X-Query-Key': API_KEY,
    'Content-Type': 'application/json'
}

params = {
    'nrql': nrql_query
}

# Send the NRQL query request
insights_response = requests.get(insights_url, headers=insights_headers, params=params)

# Check if the NRQL request was successful
if insights_response.status_code == 200:
    metrics_data = insights_response.json()
    print("Ping Metrics Data:")
    print(metrics_data)
else:
    print(f"Failed to fetch ping metrics data. Status Code: {insights_response.status_code}")
    print("Response:", insights_response.text)
