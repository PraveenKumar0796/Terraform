pipeline {
    agent any
    
    environment {
        TF_VERSION = "1.8.3" // Replace with your desired Terraform version
        AWS_CREDENTIALS = credentials('AWS_Cred')
        AWS_REGION = "us-east-1" // Replace with your AWS region
    }

    tools {
        // Use the Terraform installation defined in Global Tool Configuration
        terraform "Terraform"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/PraveenKumar0796/First_project.git'
                git checkout 'main'

            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init -backend-config="bucket=terraform0123tf" -backend-config="key=terraform.tfstate" -backend-config="region=us-east-1"'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    // Generate Terraform plan
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    // Apply Terraform changes
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
    
    post {
        always {
            // Clean up temporary files if needed
            echo 'Always executing cleanup...'
        }
    }
}
