[all]
%{ for host in hosts ~}
${host.name}
%{ endfor ~}
