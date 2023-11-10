NAME      = K8s-HW
CLUSTER   = k8s-zonal-cluster
CLUSTER_D = ${shell kubectl config get-clusters | grep -v NAME}
CONTEXT_D = ${shell kubectl config get-contexts | grep "*" | awk '{print $$2}'}
USER_D    = $(shell kubectl config get-users | grep -v NAME)

all: msfk_create msfk_attach namespase_create reddit_deploy dashboard_deploy

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
	@kubectl apply -f ../reddit/dev-namespace.yml
	@kubectl apply -f ../reddit/mongodb-service.yml -n dev
	@kubectl apply -f ../reddit/post-mongodb-service.yml -n dev
	@kubectl apply -f ../reddit/comment-mongodb-service.yml -n dev
	@kubectl apply -f ../reddit/comment-service.yml -n dev
	@kubectl apply -f ../reddit/post-service.yml -n dev
	@kubectl apply -f ../reddit/ui-service.yml -n dev
	@kubectl apply -f ../reddit/mongo-deployment.yml -n dev
	@kubectl apply -f ../reddit/post-deployment.yml -n dev
	@kubectl apply -f ../reddit/comment-deployment.yml -n dev
	@kubectl apply -f ../reddit/ui-deployment.yml -n dev

dashboard_deploy:
	@printf "\nУстановка Dasboard UI...\n"
	@kubectl apply -f ../reddit/dashboard-ui.yml
	@kubectl apply -f ../reddit/dashboard-adminuser.yml

fclean:
	@printf "Полная очистка всех конфигураций ${NAME}...\n"
	@terraform destroy -auto-approve 2>/dev/null && echo "SUCCESS: ${CLUSTER} deleted" || echo "ERROR: ${CLUSTER} deleted"
	@kubectl config delete-cluster ${CLUSTER_D}
	@kubectl config delete-context ${CONTEXT_D}
	@kubectl config delete-user ${USER_D}
	@kubectl config unset current-context

re:	fclean all

.PHONY: all msfk_create msfk_attach namespase_create reddit_deploy dashboard_deploy fclean re
