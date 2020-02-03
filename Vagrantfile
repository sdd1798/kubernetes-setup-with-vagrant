# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 config.vm.define "master" do |master| 
  master.vm.box = "hashicorp/bionic64"
  master.vm.hostname = "kubemaster"
  master.vm.provision :shell, path: "kubemaster.sh"
  master.vm.network "private_network", type: "dhcp"  
  master.vm.provider :virtualbox do |v| 
   v.customize ["modifyvm", :id, "--memory", "2048"]
   v.customize ["modifyvm", :id, "--cpus", "2"] 
  end 
 end
 (1..2).each do |i|
    config.vm.define "node-#{i}" do |node| 
     node.vm.box = "hashicorp/bionic64"
     node.vm.hostname = "kubenode#{i}" 
     node.vm.provision :shell, path: "kubenode.sh" 
     node.vm.network "private_network", type: "dhcp"  
     node.vm.provider :virtualbox do |v| 
      v.customize ["modifyvm", :id, "--memory", "2048"] 
      v.customize ["modifyvm", :id, "--cpus", "2"] 
     end 
    end
  end
end  
