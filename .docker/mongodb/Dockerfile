# Usa a imagem oficial do MongoDB
FROM mongo:8.0.3

# Configuração de variáveis de ambiente
ENV MONGO_REPLICA_PORT 27017
ENV MONGO_REPLICA_HOST localhost

# Inicia o MongoDB e configura o ReplicaSet com autenticação opcional
CMD mongod --port $MONGO_REPLICA_PORT --replSet rs0 --bind_ip 0.0.0.0 & MONGOD_PID=$!; \
    # Script para iniciar o ReplicaSet
    INIT_REPL_CMD="rs.initiate({ _id: 'rs0', members: [{ _id: 0, host: '${MONGO_REPLICA_HOST}:${MONGO_REPLICA_PORT}' }] })"; \
    # Script para criar o usuário root (caso necessário)
    INIT_USER_CMD="db.getSiblingDB('admin').getUser('${MONGO_INITDB_ROOT_USERNAME}') || \
    db.getSiblingDB('admin').createUser({ user: '${MONGO_INITDB_ROOT_USERNAME}', pwd: '${MONGO_INITDB_ROOT_PASSWORD}', roles: [{ role: 'root', db: 'admin' }] })"; \
    # Aguarda até que o ReplicaSet esteja pronto
    until mongosh --port $MONGO_REPLICA_PORT --eval "$INIT_REPL_CMD" 2>&1 | grep -q "MongoServerError: already initialized"; do \
      echo "Waiting for MongoDB ReplicaSet initialization..."; \
      sleep 2; \
    done; \
    # Cria o usuário após o ReplicaSet estar online
    echo "ReplicaSet initialized. Creating root user..." && \
    mongosh --port $MONGO_REPLICA_PORT --eval "$INIT_USER_CMD"; \
    echo "REPLICA SET ONLINE"; \
    wait $MONGOD_PID