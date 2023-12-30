1. create k8s cluster on digital ocean and downlaod kubeconfig file locally
2. download helm and kubectl and set path 
3. create jenkins-terraform user wth admin permissions and download AWS_ACCESS_KEY and AWS_SECRET_KEY
4. install jenkins through helm chart
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm pull jenkins/jenkins --untar			

helm upgrade --install jenkins jenkins/ 					--> you have to make below changes in values.yaml file and then execute
or 
helm upgrade --install jenkins jenkins/jenkins --set controller.servicePort=80 --set controller.serviceType=LoadBalancer		--> changing service type to loadbalancer so that jenkins can be directly accessible from outside cluster

kubectl exec -it jenkins-0 -- bash
cat /run/secrets/additional/chart-admin-password

pipeline{
  agent{
    kubernetes{
      defaultContainer 'terraform'	
      yaml '''
      apiVersion: v1
      kind: Pod
      metadata:
        labels:
          name: IaC
      spec:
        containers:
        - name: terraform
          image: hashicorp/terraform
          command:
          - cat
          tty: true
        - name: SCM
          image: git:alpine
          command: 
          - cat
          tty: true
       '''}
     }
   parameters{ choice(name: 'WORKFLOW',choices: ['apply','destroy'],description: 'Chose action')}
    stages{
        stage('Checkout SCM'){
            steps{
                container('git'){
                    sh 'git clone URL'
                              }
                   }
                }
         stage('Terrafrom init'){
             steps{
                 container('terraform'){
                    	withCredentials([usernamePassword(credentialsId:'terraform', passwordVariable:'AWS_ACCESS_KEY', userVariable:'AWS_SECRET_KEY')]){
					sh 'terraform init'
				}
                             }
                    }
              }
	  stage('Terrafrom ${WORKFLOW}'){
             steps{
                 container('terraform'){
                    	withCredentials([usernamePassword(credentialsId:'terraform', passwordVariable:'AWS_ACCESS_KEY', userVariable:'AWS_SECRET_KEY')]){
					sh 'terraform ${WORKFLOW} -auto-approve'
				}
                             }
                    }
              }
         }
  }

Note: make sure that remote backend is created. 