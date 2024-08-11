IMAGE_NAME := kailash-chem_analytics-image
CONTAINER_NAME := ${USER}-chem_analytics-jupyter
SERVICE_NAME := ${USER}-chem_analytics-jupyter
HOST_PORT := $(shell shuf -i 8000-17999 -n 1)

build-image:
	@cd ./devops && IMAGE_NAME=$(IMAGE_NAME) CONTAINER_NAME=$(CONTAINER_NAME) HOST_PORT=$(HOST_PORT) docker compose build 

start-container:
	@if docker ps --format '{{.Names}}' | grep -q "^$(CONTAINER_NAME)$$"; then \
		echo "Already running container: \033[1;32m$(CONTAINER_NAME)\033[0m"; \
	else export IMAGE_NAME=$(IMAGE_NAME) && export CONTAINER_NAME=$(CONTAINER_NAME) && export HOST_PORT=$(HOST_PORT) && cd ./devops && docker compose -p $(SERVICE_NAME) -f docker-compose.yml up -d > /dev/null 2>&1 ; \
		echo "Successfully started container: \033[1;32m$(CONTAINER_NAME)\033[0m"; \
		sleep 1; \
		URL="http://127.0.0.1:$(HOST_PORT)"; \
		echo "JupyterLab is running at: \033[1;34m$$URL\033[0m"; fi

enter-container:
	@echo "You are inside the Container: \033[1;33m$(CONTAINER_NAME)\033[0m"; \
	docker exec -u root -it $(CONTAINER_NAME) bash || true

stop-container:
	@if docker ps -a --format '{{.Names}}' | grep -q "^$(CONTAINER_NAME)$$"; then \
		echo "Stopped and Removed container: \033[1;31m$(CONTAINER_NAME)\033[0m"; \
		docker rm -f $(CONTAINER_NAME) > /dev/null 2>&1 || true; \
	else echo "There is no running container: \033[1;31m$(CONTAINER_NAME)\033[0m"; fi
