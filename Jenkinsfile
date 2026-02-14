pipeline{
    agent any
    parameters {
        string(name: 'AMI_ID', defaultValue: 'ami-0b6c6ebed2801a5cb', description: 'Amazon Machine Image (AMI) ID to use for the EC2 instance')
        string(name: 'AWS_CREDENTIALS_ID', defaultValue: 'aws-jenkins-creds', description: 'Jenkins AWS credentials ID')
    }
    stages {
        stage('source code') {
            steps {
                echo 'Cloning...'
                   git branch: 'main', url: 'https://github.com/PV-Sudarsan/task-jenkins.git'

            }
        }
        stage('terraform') {
            steps {
                echo 'Deploying...'
                sh '[ -n "${AMI_ID}" ] || (echo "AMI_ID is required" && exit 1)'
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: params.AWS_CREDENTIALS_ID]]) {
                    sh 'terraform init'
                    sh "terraform plan -var=\"ami_id=${params.AMI_ID}\""
                    sh "terraform apply -var=\"ami_id=${params.AMI_ID}\" -auto-approve"
                }
            }
        }
    }
}
