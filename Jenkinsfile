#!/usr/bin/env groovy


openshift.withCluster() { // Use "default" cluster or fallback to OpenShift cluster detection

    echo "Hello from the project running Jenkins: ${openshift.project()}"

        String projectName = encodeName("${JOB_NAME}")
        echo "name=${projectName}"
        

        try {
            node('maven') {
                //Do not use concurrent builds
                properties([disableConcurrentBuilds()])

                stage('checkout') {
                    checkout scm
                }

                stage('Create test project') {
                    recreateProject(projectName)

                    openshift.withProject(projectName) {

                        stage("Create build and deploy application") { 
                            openshift.newBuild("--strategy source", "--binary", "-i kb-infra/kb-s2i-solr:latest", "--name ds-solr-test")
                            openshift.startBuild("ds-solr-test", "--from-dir=.", "--follow")
                            def solr = openshift.newApp("ds-solr-test:latest")
                            openshift.set("probe", "deployment/ds-solr-test", "--readiness", "--get-url=http://:10007/solr/")
                            def pod = openshift.selector("pod", [deployment : "ds-solr-test"])
                            waitForPod(pod)

//                            timeout(1) {
  //                              pod.untilEach(1) { 
    //                                echo "pod: ${it.name()}"
      //                              return it.object().status.containerStatuses[0].ready
        //                        }
          //                  }
                            solr.narrow("dc").rollout().status()
                            openshift.create("route", "edge", "ds-solr", "--port 10007", "--service ds-solr-test")
                        }
			
                        stage("Test deployed index") {
                            def route = openshift.selector("route", "ds-solr")
                            route.describe()
                            def solrHost = route.object()
                            echo "${solrHost}"
                            sh "./test-index.sh ${solrHost.status.ingress[0].host}"
                        }

                    }
                }

                stage('Cleanup') {
                    if (env.BRANCH_NAME == 'master') {
                        echo "On master branch, letting template app run"
                    } else {
//                      echo "Not on master branch, tearing down"
//                    openshift.selector("project/${projectName}").delete()
                    }
                }
            }
        } catch (e) {
            currentBuild.result = 'FAILURE'
            throw e
        } finally {
            configFileProvider([configFile(fileId: "notifier", variable: 'notifier')]) {  
                def notifier = load notifier             
                notifier.notifyInCaseOfFailureOrImprovement(true, "#playground")
            } 
        }
    }

private void waitForPod(Selector pod) {
    timeout(1) {
        try {
            pod.untilEach(1) {
                echo "pod: ${it.name()}"
                return it.object().status.containerStatuses[0].ready
            }
        } catch (e) {
            echo "Got execption while waiting" + e
        }
    }
}

private void recreateProject(String projectName) {
    echo "Delete the project ${projectName}, ignore errors if the project does not exist"
    try {
        openshift.selector("project/${projectName}").delete()

        openshift.selector("project/${projectName}").watch {
            echo "Waiting for the project ${projectName} to be deleted"
            return it.count() == 0
        }

    } catch (e) {

    }
//
//    //Wait for the project to be gone
//    sh "until ! oc get project ${projectName}; do date;sleep 2; done; exit 0"

    echo "Create the project ${projectName}"
    openshift.newProject(projectName)
}

/**
 * Encode the jobname as a valid openshift project name
 * @param jobName the name of the job
 * @return the jobname as a valid openshift project name
 */
private static String encodeName(groovy.lang.GString jobName) {
    def jobTokens = jobName.tokenize("/")
    def org = jobTokens[0]
    if(org.contains('-')) {
        org = org.tokenize("-").collect{it.take(1)}.join("")
    } else {
        org = org.take(3)
    }

    // Repository have a very long name, lets shorten it further
    def repo = jobTokens[1]
    if(repo.contains('-')) {
        repo = repo.tokenize("-").collect{it.take(1)}.join("")
    } else if(repo.contains('_')) {
        repo = repo.tokenize("_").collect{it.take(1)}.join("")
    } else {
        repo = repo.take(3)
    }


    def name = ([org, repo] + jobTokens.drop(2)).join("-")
            .replaceAll("\\s", "-")
            .replaceAll("_", "-")
            .replace("/", '-')
            .replaceAll("^openshift-", "")
            .toLowerCase()
    return name
}

