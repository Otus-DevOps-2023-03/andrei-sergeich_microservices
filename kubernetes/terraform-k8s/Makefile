NAME      = K8s-HW
CLUSTER   = k8s-zonal-cluster
DISK_NAME = k8s-cloud-disk


all: disk_create msfk_create msfk_attach \
	ingress_controller_deploy reddit_deploy dashboard_deploy ingress_deploy

DISK_NAME_CHECK = ${shell yc compute disk list --format json | jq -r '.[] | select (.name == "${DISK_NAME}") | .name'}
disk_create:
	@echo
	@echo "$$(tput bold)Создание Compute Cloud Disk...$$(tput sgr0)"
ifneq '${DISK_NAME_CHECK}' '${DISK_NAME}'
	@yc compute disk create --name ${DISK_NAME} --size 4 --description "disk for ${DISK_NAME}"
	@sleep 5
	@sed -i \
		'/volumeHandle/s/:.*$\/\: ${shell yc compute disk list --format json | jq -r '.[] | select (.name == "${DISK_NAME}") | .id'}/' \
		../reddit/mongo-volume.yml
else
	@printf "Compute Cloud Disk ${DISK_NAME} уже существует\n"
endif

msfk_create:
	@echo
	@echo "$$(tput bold)Создание кластера Managed Service for Kubernetes...$$(tput sgr0)"
	@terraform apply -auto-approve

msfk_attach:
	@echo
	@echo "$$(tput bold)Создание контекста...$$(tput sgr0)"
	@yc managed-kubernetes cluster get-credentials ${CLUSTER} --external

ingress_controller_deploy:
	@echo
	@echo "$$(tput bold)Установка Ingress controller...$$(tput sgr0)"
	@kubectl apply -f ../reddit/ingress-nginx.yml

reddit_deploy:
	@echo
	@echo "$$(tput bold)Установка приложения в ${CLUSTER}...$$(tput sgr0)"
	@kubectl apply -f ../reddit/dev-namespace.yml
	@kubectl apply -f ../reddit/mongo-volume.yml -n dev
	@kubectl apply -f ../reddit/mongo-claim.yml -n dev
	@kubectl apply -f ../reddit/mongo-deployment.yml -n dev
	@kubectl apply -f ../reddit/mongodb-service.yml -n dev
	@kubectl apply -f ../reddit/comment-deployment.yml -n dev
	@kubectl apply -f ../reddit/comment-service.yml -n dev
	@kubectl apply -f ../reddit/comment-mongodb-service.yml -n dev
	@kubectl apply -f ../reddit/post-deployment.yml -n dev
	@kubectl apply -f ../reddit/post-service.yml -n dev
	@kubectl apply -f ../reddit/post-mongodb-service.yml -n dev
	@kubectl apply -f ../reddit/ui-deployment.yml -n dev
	@kubectl apply -f ../reddit/ui-service.yml -n dev
	@kubectl apply -f ../reddit/ui-secret.yml -n dev
	@kubectl apply -f ../reddit/mongo-network-policy.yml -n dev

dashboard_deploy:
	@echo
	@echo "$$(tput bold)Установка Dasboard UI...$$(tput sgr0)"
	@kubectl apply -f ../reddit/dashboard-ui.yml
	@kubectl apply -f ../reddit/dashboard-adminuser.yml

INGR_CONT_STATE = $(shell kubectl get po -n ingress-nginx | grep controller | awk '{print$$2}' | awk -F '/' '{print$$1}')
ingress_deploy:
	@echo
	@echo "$$(tput bold)Создание Ingress...$$(tput sgr0)"
	@sleep 10
ifeq '${INGR_CONT_STATE}' '1'
	@kubectl apply -f ../reddit/ui-ingress.yml -n dev
else
	@make ingress_deploy
endif

disk_destroy:
	@echo
	@echo "$$(tput bold)Удаление Compute Cloud Disk...$$(tput sgr0)"
	@yc compute disk delete ${DISK_NAME}

CLUSTER_D = ${shell kubectl config get-clusters | grep -v NAME}
CONTEXT_D = ${shell kubectl config get-contexts | grep "*" | awk '{print $$2}'}
USER_D    = $(shell kubectl config get-users | grep -v NAME)
clean:
	@echo
	@echo "$$(tput bold)Удаление приложения, Ingress controller, контекста...$$(tput sgr0)"
	@kubectl delete -f ../reddit/mongo-network-policy.yml -n dev
	@kubectl delete -f ../reddit/ui-ingress.yml -n dev
	@kubectl delete -f ../reddit/ui-secret.yml -n dev
	@kubectl delete -f ../reddit/ui-service.yml -n dev
	@kubectl delete -f ../reddit/ui-deployment.yml -n dev
	@kubectl delete -f ../reddit/post-mongodb-service.yml -n dev
	@kubectl delete -f ../reddit/post-service.yml -n dev
	@kubectl delete -f ../reddit/post-deployment.yml -n dev
	@kubectl delete -f ../reddit/comment-mongodb-service.yml -n dev
	@kubectl delete -f ../reddit/comment-service.yml -n dev
	@kubectl delete -f ../reddit/comment-deployment.yml -n dev
	@kubectl delete -f ../reddit/mongodb-service.yml -n dev
	@kubectl delete -f ../reddit/mongo-deployment.yml -n dev
	@kubectl delete -f ../reddit/mongo-claim.yml -n dev
	@kubectl delete -f ../reddit/mongo-volume.yml -n dev
	@kubectl delete -f ../reddit/dev-namespace.yml
	@kubectl delete -f ../reddit/ingress-nginx.yml
	@kubectl config delete-cluster ${CLUSTER_D}
	@kubectl config delete-context ${CONTEXT_D}
	@kubectl config delete-user ${USER_D}
	@kubectl config unset current-context

fclean: clean disk_destroy
	@echo
	@echo "$$(tput bold)Полная очистка всех конфигураций ${NAME}...$$(tput sgr0)"
	@terraform destroy -auto-approve 2>/dev/null && echo "SUCCESS: ${CLUSTER} deleted" || echo "ERROR: ${CLUSTER} deleted"

re:	fclean all

.PHONY: all disk_create msfk_create msfk_attach ingress_controller_deploy \
		reddit_deploy dashboard_deploy ingress_deploy disk_destroy clean fclean re
