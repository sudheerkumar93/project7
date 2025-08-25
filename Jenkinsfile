pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    environment {
        ARM_CLIENT_ID     = '7b66f0b0-c43e-4682-9024-666bf29bda03'
        ARM_CLIENT_SECRET = 'cnE8Q~eYwUibzVv7llCNXxM8IgR_LQbmw2fj2csF'
        ARM_SUBSCRIPTION_ID = '75279c7b-6f2e-4e76-ae48-b6aeab569b34'
        ARM_TENANT_ID     = '766ef0d9-c1c7-4a7f-93ca-5e74124c5fc9'
    }

    stages {
        // The 'Checkout' stage has been removed because Jenkins
        // automatically checks out the repository to get the Jenkinsfile.

        stage('Maven') {
            steps {
                sh 'mvn clean package -Dcheckstyle.skip=true'
            }
        }

        stage('Archive Artifact') {
            steps {
                 sh 'mv target/*.jar target/sunnyspringpetclinic.jar'
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
                    az webapp deploy --resource-group pipeline --name sunny-web-app-jenkins-3 --type jar --src-path target/sunnyspringpetclinic.jar
                '''
            }
        }
    }
}
