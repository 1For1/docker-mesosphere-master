#!groovy

import groovy.json.JsonOutput

// Get all Causes for the current build
//def causes = currentBuild.rawBuild.getCauses()
//def specificCause = currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause)

//echo "Cause: ${causes}"
//echo "SpecificCause: ${specificCause}"

stage 'DockerBuild'
slackSend color: 'blue', message: "ORG: ${env.JOB_NAME} #${env.BUILD_NUMBER} - Starting Docker Build"
node ('docker-cmd'){
    //env.PATH = "${tool 'Maven 3'}/bin:${env.PATH}"

    checkout scm

    sh "echo Working on BRANCH ${env.BRANCH_NAME} for ${env.BUILD_NUMBER}"

    dockerlogin()
    dockerrmi("oneforone/docker-mesosphere-master:${env.BRANCH_NAME}.${env.BUILD_NUMBER}")
    dockerbuild("oneforone/docker-mesosphere-master:${env.BRANCH_NAME}.${env.BUILD_NUMBER}")
}

stage 'DockerHub'
slackSend color: 'green', message: "ORG: ${env.JOB_NAME} #${env.BUILD_NUMBER} - Pushing to Docker"
node('docker-cmd') {
    dockerlogin()
    dockerpush("oneforone/docker-mesosphere-master:${env.BRANCH_NAME}.${env.BUILD_NUMBER}")

}

switch ( env.BRANCH_NAME ) {
    case "master":


        node('docker-cmd') {
            stage 'DockerLatest'
            //slackSend color: 'blue',  message: "ORG: ${env.JOB_NAME} #${env.BUILD_NUMBER} - Stopping DEV Services"

            parallel (
                master001: { dockerstop('dev-service-mesos-master-001' },
                slave001: { dockerstop('dev-service-mesos-slave-001' },
                slave002: { dockerstop('dev-service-mesos-slave-002' },
                slave003: { dockerstop('dev-service-mesos-slave-003' }
            )

            parallel (
                master001: { dockerrm('dev-service-mesos-master-001' },
                slave001: { dockerrm('dev-service-mesos-slave-001' },
                slave002: { dockerrm('dev-service-mesos-slave-002' },
                slave003: { dockerrm('dev-service-mesos-slave-003' }
            )

            slackSend color: 'blue', message: "ORG: ${env.JOB_NAME} #${env.BUILD_NUMBER} - Removing latest tag"
            // Erase
            dockerrmi('oneforone/docker-mesosphere-master:latest')

            // Tag
            dockertag("oneforone/docker-mesosphere-master:${env.BRANCH_NAME}.${env.BUILD_NUMBER}","oneforone/docker-mesosphere-master:latest")

            // Push
            slackSend color: 'blue', message: "ORG: ${env.JOB_NAME} #${env.BUILD_NUMBER} - Pushing :latest"
            dockerpush('oneforone/docker-mesosphere-master:latest')
        }

        stage 'Sleep'
        sleep 30

        stage 'Downstream'
        slackSend color: 'blue', message: "ORG: ${env.JOB_NAME} #${env.BUILD_NUMBER} - Building Downstream"
        build '/OPS-Dev-Services/dev-service-mesos-master-001'

        break

    default:
        echo "Branch is not master.  Skipping tagging and push.  BRANCH: ${env.BRANCH_NAME}"
}


// Functions


// Docker functions
def dockerlogin() {
    sh "docker -H tcp://10.1.10.210:5001 login -e ${env.DOCKER_EMAIL} -u ${env.DOCKER_USER} -p ${env.DOCKER_PASSWD}"
}

def dockerbuild(label) {
    sh "docker -H tcp://10.1.10.210:5001 build -t ${label} ."
}
def dockerstop(vm) {
    sh "docker -H tcp://10.1.10.210:5001 stop ${vm} || echo stop ${vm} failed"
}

def dockerrmi(vm) {
    sh "docker -H tcp://10.1.10.210:5001 rmi -f ${vm} || echo RMI Failed"
}

def dockerrm(vm) {
    sh "docker -H tcp://10.1.10.210:5001 rm -f ${vm} || echo RM Failed"
}

def dockertag(label_old, label_new) {
    sh "docker -H tcp://10.1.10.210:5001 tag -f ${label_old} ${label_new}"
}

def dockerpush(vm) {
    sh "docker -H tcp://10.1.10.210:5001 push ${vm}"
}
