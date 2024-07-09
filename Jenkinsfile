pipeline {
    agent any
    
    environment {
        AWS_CREDENTIALS = credentials('AWS_Cred')
        AWS_DEFAULT_REGION    = 'us-east-1'  // Replace with your AWS region
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout code from GitHub repository
                    git branch: 'main', url: 'https://github.com/PraveenKumar0796/Terraform.git'
                }
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform (install plugins, modules, etc.)
                    bat 'terraform init -input=false'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    // Generate and show Terraform plan
                    bat 'terraform plan -out=tfplan -input=false -lock=false'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    // Apply Terraform changes (auto-approve for non-interactive execution)
                    bat 'terraform apply -input=false -lock=false -auto-approve tfplan'
                }
            }
        }
        
         //stage('Terraform Destroy') {
           // steps {
               // script {
                    // Apply Terraform changes (auto-approve for non-interactive execution)
                 //   bat 'terraform destroy -input=false -lock=false -auto-approve'
              //  }
           // }
        //}
}
    
    post {
        always {
            // Clean up Terraform files and directories if needed
            cleanWs()
        }
    }
}


