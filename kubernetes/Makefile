NAME = K8s-HW

# TODO: переместить в каталог teraaform, переписать по "make -C $(TF{-k8s}_DIR)", описать изменения в README.md

all: infra_create k8s_create

infra_create:
	@printf "Создание инфраструктуры в облаке...\n"
	@cd ./terraform && terraform apply -auto-approve

k8s_create:
	@printf "Ожидание поднятия инстансов для ${NAME}...\n"
	@sleep 20
	@printf "Создание кластера ${NAME}...\n"
	@cd ./ansible && ansible-playbook playbook_deploy.yml

fclean:
	@printf "Полная очистка всех конфигураций ${NAME}...\n"
	@cd ./terraform && terraform destroy -auto-approve 2>/dev/null && echo "SUCCESS: yc compute instance deleted" || echo "ERROR: yc compute instance deleted"

re:	fclean all

.PHONY: all infra_create k8s_create fclean re
