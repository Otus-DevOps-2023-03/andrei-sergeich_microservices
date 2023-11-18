NAME        = K8s-HW
CLUSTER     = k8s-zonal-cluster
CLUSTER_D   = ${shell kubectl config get-clusters | grep -v NAME}
CONTEXT_D   = ${shell kubectl config get-contexts | grep "*" | awk '{print $$2}'}
USER_D      = $(shell kubectl config get-users | grep -v NAME)
INGR_CONT_S = $(shell kubectl get po -n ingress-nginx | grep controller | awk '{print$$2}' | awk -F '/' '{print$$1}')


all: msfk_create msfk_attach \
	ingress_controller_deploy reddit_deploy dashboard_deploy ingress_deploy

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
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.3/deploy/static/provider/cloud/deploy.yaml

reddit_deploy:
	@echo
	@echo "$$(tput bold)Установка приложения в ${CLUSTER}...$$(tput sgr0)"
	@kubectl apply -f ../reddit/dev-namespace.yml
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

dashboard_deploy:
	@echo
	@echo "$$(tput bold)Установка Dasboard UI...$$(tput sgr0)"
	@kubectl apply -f ../reddit/dashboard-ui.yml
	@kubectl apply -f ../reddit/dashboard-adminuser.yml

ingress_deploy:
	@echo
	@echo "$$(tput bold)Создание Ingress...$$(tput sgr0)"
	@sleep 5
ifeq '${INGR_CONT_S}' '1'
	@kubectl apply -f ../reddit/ui-ingress.yml -n dev
else
	@make ingress_deploy
endif

clean:
	@echo
	@echo "$$(tput bold)Удаление приложения, Ingress controller, контекста...$$(tput sgr0)"
	@kubectl delete -f ../reddit/ui-ingress.yml -n dev
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
	@kubectl delete -f ../reddit/dev-namespace.yml
	@kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.3/deploy/static/provider/cloud/deploy.yaml
	@kubectl config delete-cluster ${CLUSTER_D}
	@kubectl config delete-context ${CONTEXT_D}
	@kubectl config delete-user ${USER_D}
	@kubectl config unset current-context

fclean: clean
	@printf "Полная очистка всех конфигураций ${NAME}...\n"
	@terraform destroy -auto-approve 2>/dev/null && echo "SUCCESS: ${CLUSTER} deleted" || echo "ERROR: ${CLUSTER} deleted"

re:	fclean all

.PHONY: all msfk_create msfk_attach ingress_controller_deploy reddit_deploy dashboard_deploy ingress_deploy clean fclean re
