NAME      = K8s-HW
CLUSTER   = k8s-zonal-cluster
CLUSTER_D = ${shell kubectl config get-clusters | grep -v NAME}
CONTEXT_D = ${shell kubectl config get-contexts | grep "*" | awk '{print $$2}'}
USER_D    = $(shell kubectl config get-users | grep -v NAME)

all: msfk_create msfk_attach namespase_create reddit_deploy

msfk_create:
	@printf "Создание кластера Managed Service for Kubernetes...\n"
	@terraform apply -auto-approve

msfk_attach:
	@printf "\nСоздание контекста...\n"
	@yc managed-kubernetes cluster get-credentials ${CLUSTER} --external

namespase_create:
	@printf "\nСоздание namespase для ${CLUSTER}...\n"
	@kubectl apply -f ../reddit/dev-namespace.yml

reddit_deploy:
	@printf "\nРазвертывание приложения в ${CLUSTER}...\n"
	@kubectl apply -f ../reddit/ -n dev

fclean:
	@printf "Полная очистка всех конфигураций ${NAME}...\n"
	@terraform destroy -auto-approve 2>/dev/null && echo "SUCCESS: ${CLUSTER} deleted" || echo "ERROR: ${CLUSTER} deleted"
	@kubectl config delete-cluster ${CLUSTER_D}
	@kubectl config delete-context ${CONTEXT_D}
	@kubectl config delete-user ${USER_D}

re:	fclean all

.PHONY: all msfk_create msfk_attach namespase_create reddit_deploy fclean re
