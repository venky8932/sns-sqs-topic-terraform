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
