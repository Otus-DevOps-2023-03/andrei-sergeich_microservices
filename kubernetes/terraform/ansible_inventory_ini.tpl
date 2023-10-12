[k8s]
%{ for index, ip in master ~}
master ansible_host=${ip}
%{ endfor ~}
%{ for index, ip in worker ~}
worker ansible_host=${ip}
%{ endfor ~}
