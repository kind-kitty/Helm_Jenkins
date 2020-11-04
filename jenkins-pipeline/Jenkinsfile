node ('master') {
    def commit_id
    def git_repo_name
    stage('checkout') {
        // This is pulling repository from github
        // You don't need to change anything in this stage.
        checkout scm
        echo "Checking out repository from github."

        // Reading git repository name to use while building docker image.
        git_repo_name = sh (
            script: 'basename `git rev-parse --show-toplevel`',
            returnStdout: true
        ).trim()
        echo "Repository Name : ${git_repo_name}"

        // Reading git commit-id for tagging docker image.
        commit_id= sh (
            script: 'git rev-parse --short HEAD',
            returnStdout: true
        ).trim()
        echo "Checked out Commit ID : ${commit_id} from github"
    }
    stage('test') {
        echo "No tests to run."
        // Please add command to run your tests here
        // Ex : sh "npm test"
    }
    stage('build') {
        echo "Buidling docker images using Dockerfile in root directory."
        // docker.build('<docker-image-name>','<path-to-Dockerfile>')
        docker.build("${git_repo_name}",'.')
        echo "Success - Docker image Built."
    }
}
