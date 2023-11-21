# branch staging

### build, test and deploy containerized node.js web app via jenkins

##### (Discover branch difference in Jenkinsfile)

##### Configuring GitHub WebHook
![Configuring GitHub WebHook](screenshots/Configuring%20GitHub%20WebHook.png)

##### Backup via DockerHub
![Backup via DockerHub](screenshots/Backup%20via%20DockerHub%20.png)

##### Parametrized Run
![Parametrized Run](screenshots/Parametrized%20Run.png)

##### Jenkins Pipeline (Jenkins Host uses HTTPS and Wildcard DNS)
![Jenkins Pipeline](screenshots/Jenkins%20Pipeline.png)

##### Successful Deploy Log
![Successful Deploy Log](screenshots/Successful%20Deploy%20Log.png)


#### Problem: Not enough RAM (1GB on AWS EC2 t3.micro vs minimum 2GB unofficially recommended)

##### Without swap file
![Without swap file](screenshots/Problem/Without%20swap%20file.png)

#### Solution: Add swap file

##### After configuring swap file
![After configuring swap file](screenshots/Problem/After%20configuring%20swap%20file.png)