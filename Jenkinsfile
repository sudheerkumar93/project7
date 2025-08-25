pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        ARM_CLIENT_ID     = credentials('azure-sp')
        ARM_CLIENT_SECRET = credentials('azure-sp')
        ARM_SUBSCRIPTION_ID = '75279c7b-6f2e-4e76-ae48-b6aeab569b34'
        ARM_TENANT_ID     = credentials('azure-tenant')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/sudheerkumar93/project7'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package -Dcheckstyle.skip=true'
            }
        }

        stage('Archive Artifact') {
            steps {
                sh 'mv target/*.jar target/luckyspringpetclinic.jar'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Terraform Init') {
            steps {
                dir('infra') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('infra') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('infra') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                sh '''
                    az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
                    az webapp deploy --resource-group john --name lucky-web-app --type jar --src-path target/luckyspringpetclinic.jar
                '''
            }
        }
    }
}
