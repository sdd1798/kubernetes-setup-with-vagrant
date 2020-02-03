# kubernetes-setup-with-vagrant
Create Kubernetes cluster on local machine using vagrant 
## Prerequisites
* Virtual Box v6.0.14
* Vagrant (latest)
* Kubectl (latest)

## Steps to setup kubernetes cluster
* First clone the repository and run `vagrant up` command
* By default this will create kubernetes cluster with a master and 2 slave node.
* If you wish the change the count of slave nodes, change to whatever count you want in following statement in Vagrantfile

  `(1..2).each do |i|`
* kubemaster.sh and kubenode.sh are the bash scripts that will configure the master and slave nodes respectively.
* After successfull setup of kubernetes, you will have Kubeconfig file in the current directory with name vagrantKubeConfig using which you can fire kubectl from your local machine.
* Use following command to set conext of kubectl to newly created kubernetes cluster

  `export KUBECONFIG= <Path to vagrantKubeConfig file>` 
* Finally check if you are connected to the cluster using command
  
  `kubectl get nodes`
  
  You should get 3 nodes in ready state if you haven't change the count of slave nodes.
  
